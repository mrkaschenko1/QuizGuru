// 🎯 Dart imports:
import 'dart:async';
import 'dart:core';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timezone/timezone.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/exceptions/base_exception.dart';
import 'package:Quiz_Guru/exceptions/network_exception.dart';
import 'package:Quiz_Guru/models/question_model.dart';
import 'package:Quiz_Guru/models/test_model.dart';
import 'package:Quiz_Guru/network/network_info.dart';
import 'package:Quiz_Guru/repositories/user_repository.dart';

class TestRepository {
  final NetworkInfo networkInfo;
  final UserRepository _userRepository;
  final FirebaseDatabase _firebaseDatabase;

  TestRepository(
      {@required UserRepository userRepository,
      @required FirebaseDatabase firebaseDatabase,
      @required this.networkInfo})
      : _userRepository = userRepository,
        _firebaseDatabase = firebaseDatabase;

  Future<Either<BaseException, List<TestModel>>>
      getTestsWithStatistics() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }

    final tests = await _firebaseDatabase.reference().child('tests').once();

    final userTestsPassed = await _firebaseDatabase
        .reference()
        .child('users')
        .child(_userRepository.user.uid)
        .child('tests_passed')
        .once();

    final List<TestModel> result = [];

    await tests.value.forEach((String key, Map<String, dynamic> value) {
      final testId = key;
      var userTries = 0;
      var bestScore = 0;
      try {
        final dynamic userExperience = userTestsPassed.value[testId];
        userTries = userExperience['user_tries'] as int;
        bestScore = userExperience['best_score'] as int;
      } catch (e) {
        rethrow;
      }
      result.add(TestModel(
        id: key,
        questions: value['questions'] == null
            ? null
            : (value['questions'])
                .map<QuestionModel>(
                    (Map<dynamic, dynamic> i) => QuestionModel.fromJson(i))
                .toList() as List<QuestionModel>,
        studentsPassed: value['students_passed'] as int,
        averageScore: value['average_score'] as double,
        totalPoints: value['total_points'] as int,
        title: value['title'] as String,
        userTries: userTries,
        tries: value['tries'] as int ?? 0,
        userBestScore: bestScore,
      ));
    });
    return Right(result);
  }

  //runs before test starts
  Future<Either<BaseException, Map<String, dynamic>>>
      runTestsPassedTransactionOnTest({String testId}) async {
    final bool isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    try {
      var isTestPassed = false;

      final TransactionResult transactionResult = await _firebaseDatabase
          .reference()
          .child('users')
          .child(_userRepository.user.uid)
          .runTransaction((MutableData userTest) async {
        if (userTest == null) {
          return userTest;
        }
        if (userTest.value == null) {
          return userTest;
        }
        if (!(userTest.value.containsKey('tests_passed') as bool)) {
          userTest.value['tests_passed'] = <String, dynamic>{};
        }
        if (!(userTest.value['tests_passed'].containsKey(testId) as bool)) {
          // print("we don't have our test in user list");
          final dynamic testsPassed = userTest.value['tests_passed'];
          testsPassed[testId] = {
            'user_tries': 1,
            'best_score': 0,
            'attempts': {"1": "not yet"}
          };
          userTest.value['tests_passed'] = testsPassed;
        } else {
          // print('we have our test in list');
          isTestPassed = true;

          await userTest.value['tests_passed'][testId]['user_tries']++;
        }
        return userTest;
      });

      final currentAttempt = await _firebaseDatabase
          .reference()
          .child('users')
          .child(_userRepository.user.uid)
          .child('tests_passed/$testId/user_tries')
          .once()
          .then((DataSnapshot value) => value.value as FutureOr<int>);
      // print('current attempt $currentAttempt');
      await _firebaseDatabase
          .reference()
          .child('users')
          .child(_userRepository.user.uid)
          .child('tests_passed/$testId/attempts')
          .update(<String, dynamic>{
        currentAttempt.toString(): {
          "start_time": TZDateTime.now(local).toIso8601String()
        }
      });

      return Right(<String, dynamic>{
        'transaction_result': transactionResult,
        'is_test_passed': isTestPassed
      });
    } catch (e) {
      return Left(BaseException(e.toString()));
    }
  }

  Future<Either<BaseException, TransactionResult>>
      runTestIncrementTransactionOnTest(
          {String testId, bool isTestPassed}) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    final transactionResult = await _firebaseDatabase
        .reference()
        .child('tests')
        .child(testId)
        .runTransaction((test) async {
      if (test == null) {
        return test;
      }
      if (test.value == null) {
        return test;
      }
      await test.value['total_tries']++;
      if (!isTestPassed) {
        await test.value['students_passed']++;
      }
      return test;
    });
    return Right(transactionResult);
  }

  Future<Either<BaseException, Map<String, dynamic>>>
      runUpdatePointsAndBestScore({String testId, int currentScore}) async {
    final bool isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    final String userId = _userRepository.user.uid;
    final userRef = _firebaseDatabase.reference().child('users').child(userId);
    int diff = 0;
    final TransactionResult transaction =
        await userRef.runTransaction((MutableData user) async {
      if (user == null) {
        return user;
      }
      if (user.value == null) {
        return user;
      }
      final dynamic test = await user.value['tests_passed'][testId];
      final int prevBestScore = test['best_score'] as int;
      if (currentScore > prevBestScore) {
        diff = currentScore - prevBestScore;
        user.value['points'] += diff;
        test['best_score'] = currentScore;
      }

      return user;
    });

    final int currentAttempt = await _firebaseDatabase
        .reference()
        .child('users')
        .child(_userRepository.user.uid)
        .child('tests_passed/$testId/user_tries')
        .once()
        .then((DataSnapshot value) => value.value as FutureOr<int>);
    await _firebaseDatabase
        .reference()
        .child('users')
        .child(_userRepository.user.uid)
        .child('tests_passed/$testId/attempts/${currentAttempt.toString()}')
        .update(<String, dynamic>{
      'end_time': TZDateTime.now(local).toIso8601String(),
      'score': currentScore
    });

    return Right(
        <String, dynamic>{'transaction_result': transaction, 'diff': diff});
  }

  Future<Either<BaseException, TransactionResult>> runUpdateTestPoints(
      String testId, int diff) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    final totalPointsRef = _firebaseDatabase
        .reference()
        .child('tests')
        .child(testId)
        .child('total_points');
    final transactionResult =
        await totalPointsRef.runTransaction((testPoints) async {
      if (testPoints == null) {
        return testPoints;
      }
      if (testPoints.value == null) {
        return testPoints;
      }
      // print(testPoints.value);
      testPoints.value += diff;
      return testPoints;
    });
    return Right(transactionResult);
  }
}
