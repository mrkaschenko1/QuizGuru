// 🎯 Dart imports:
import 'dart:core';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timezone/timezone.dart';

// 🌎 Project imports:
import '../exceptions/base_exception.dart';
import '../exceptions/network_exception.dart';
import '../models/question_model.dart';
import '../models/test_model.dart';
import '../network/network_info.dart';
import '../repositories/user_repository.dart';

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
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    var tests = await _firebaseDatabase.reference().child('tests').once();

    var userTestsPassedInfo = await _firebaseDatabase
        .reference()
        .child('users')
        .child(_userRepository.user.uid)
        .child('tests_passed')
        .once();

    final List<TestModel> result = [];

    await tests.value.forEach((key, value) {
      print(value['tries']);
      final testId = key;
      var userTries = 0;
      var bestScore = 0;
      try {
        var userExperience = userTestsPassedInfo.value[testId];
        userTries = userExperience['user_tries'];
        bestScore = userExperience['best_score'];
      } catch (e) {}
      result.add(TestModel(
        id: key,
        questions: value['questions'] == null
            ? null
            : (value['questions'])
                .map<QuestionModel>((i) => QuestionModel.fromJson(i))
                .toList() as List<QuestionModel>,
        studentsPassed: value['students_passed'],
        averageScore: value['average_score'],
        totalPoints: value['total_points'],
        title: value['title'],
        userTries: userTries,
        tries: value['tries'] ?? null,
        userBestScore: bestScore,
      ));
    });
    return Right(result);
  }

  //runs before test starts
  Future<Either<BaseException, Map<String, dynamic>>>
      runTestsPassedTransactionOnTest(
          {bool isTestPassed, String testId}) async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    try {
      final transactionResult = await _firebaseDatabase
          .reference()
          .child('users')
          .child(_userRepository.user.uid)
          .runTransaction((userTest) async {
        if (userTest == null) {
          return userTest;
        }
        if (userTest.value == null) {
          return userTest;
        }
        if (!userTest.value.containsKey('tests_passed')) {
          print('making tests_passed list');
          userTest.value['tests_passed'] = Map<dynamic, dynamic>();
        }
        if (!userTest.value['tests_passed'].containsKey(testId)) {
          print('we don\'t have our test in user list');
          var testsPassed = userTest.value['tests_passed'];
          testsPassed[testId] = {
            'user_tries': 1,
            'best_score': 0,
            'attempts': {"1": "not yet"}
          };
          userTest.value['tests_passed'] = testsPassed;
        } else {
          print('we have our test in list');
          isTestPassed = true;

          await userTest.value['tests_passed'][testId]['user_tries']++;
        }
        return userTest;
      });

      int currentAttempt = await _firebaseDatabase
          .reference()
          .child('users')
          .child(_userRepository.user.uid)
          .child('tests_passed/$testId/user_tries')
          .once()
          .then((value) => value.value);
      print('current attempt $currentAttempt');
      await _firebaseDatabase
          .reference()
          .child('users')
          .child(_userRepository.user.uid)
          .child('tests_passed/$testId/attempts')
          .update({
        currentAttempt.toString(): {
          "start_time": TZDateTime.now(local).toIso8601String()
        }
      });

      return Right({
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
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    var transactionResult = await _firebaseDatabase
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
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    final userId = _userRepository.user.uid;
    var userRef = _firebaseDatabase.reference().child('users').child(userId);
    var diff = 0;
    var transaction = await userRef.runTransaction((user) async {
      if (user == null) {
        return user;
      }
      if (user.value == null) {
        return user;
      }
      var test = await user.value['tests_passed'][testId];
      print(test['best_score']);
      var prevBestScore = test['best_score'];
      if (currentScore > prevBestScore) {
        diff = currentScore - prevBestScore;
        user.value['points'] += diff;
        test['best_score'] = currentScore;
      }

      return user;
    });

    int currentAttempt = await _firebaseDatabase
        .reference()
        .child('users')
        .child(_userRepository.user.uid)
        .child('tests_passed/$testId/user_tries')
        .once()
        .then((value) => value.value);
    print('current attempt $currentAttempt');
    await _firebaseDatabase
        .reference()
        .child('users')
        .child(_userRepository.user.uid)
        .child('tests_passed/$testId/attempts/${currentAttempt.toString()}')
        .update({
      'end_time': TZDateTime.now(local).toIso8601String(),
      'score': currentScore
    });

    return Right({'transaction_result': transaction, 'diff': diff});
  }

  Future<Either<BaseException, TransactionResult>> runUpdateTestPoints(
      String testId, int diff) async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    var totalPointsRef = _firebaseDatabase
        .reference()
        .child('tests')
        .child(testId)
        .child('total_points');
    var transactionResult =
        await totalPointsRef.runTransaction((testPoints) async {
      if (testPoints == null) {
        return testPoints;
      }
      if (testPoints.value == null) {
        return testPoints;
      }
      print(testPoints.value);
      testPoints.value += diff;
      return testPoints;
    });
    return Right(transactionResult);
  }
}
