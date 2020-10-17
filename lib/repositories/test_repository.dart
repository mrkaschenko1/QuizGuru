import 'dart:convert';

import 'package:android_guru/exceptions/base_exception.dart';
import 'package:android_guru/exceptions/network_exception.dart';
import 'package:android_guru/models/question_model.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/network/network_info.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class TestRepository {
  final NetworkInfo networkInfo;
  final UserRepository _userRepository;
  final FirebaseDatabase _firebaseDatabase;

  TestRepository({
    @required UserRepository userRepository,
    @required FirebaseDatabase firebaseDatabase,
    @required NetworkInfo this.networkInfo
  })
      :
        _userRepository = userRepository,
        _firebaseDatabase = firebaseDatabase;


  Future<Either<BaseException, List<TestModel>>> getTestsWithStatistics() async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    var tests = await _firebaseDatabase
        .reference()
        .child('tests').once();

    var userTestsPassedInfo = await _firebaseDatabase
        .reference()
        .child('users')
        .child(_userRepository.user.uid)
        .child('tests_passed')
        .once();

    final List<TestModel> result = [];

    await tests.value.forEach((key, value) {
      final testId = key;
      var userTries = 0;
      var bestScore = 0;
      try {
        var userExperience = userTestsPassedInfo.value.firstWhere((elem) {
          return elem.keys.first == testId;
        })[testId];
        userTries = userExperience['user_tries'];
        bestScore = userExperience['best_score'];
      } catch (e) {
      }
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
        userBestScore: bestScore,
      )
      );
    });
    return Right(result);
  }

  //runs before test starts
  Future<Either<BaseException, Map<String, dynamic>>> runTestsPassedTransactionOnTest(
      {
        bool isTestPassed,
        String testId
      }
    ) async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    final transactionResult = await _firebaseDatabase.reference().runTransaction((userTest) async {
      if (userTest == null) {
        return userTest;
      }
      if (userTest.value == null) {
        return userTest;
      }
      if (!userTest.value.containsKey('tests_passed')) {
        print('making tests_passed list');
        userTest.value['tests_passed'] = List<dynamic>();
      }
      if (!userTest.value['tests_passed']
          .any((e) => e.keys.contains(testId) ? true : false)) {
        print('we don\'t have our test in user list');
        var testsPassed =
        List.of(userTest.value['tests_passed'], growable: true);
        testsPassed.add({
          testId: {
            'user_tries': 1,
            'best_score': 0,
          }
        });
        userTest.value['tests_passed'] = testsPassed;
      } else {
        print('we have our test in list');
        isTestPassed = true;
        var index = userTest.value['tests_passed']
            .indexWhere((e) => e.keys.contains(testId) ? true : false);
        await userTest.value['tests_passed'][index][testId]
        ['user_tries']++;
      }
      return userTest;
    });
    return Right({
      'transaction_result': transactionResult,
      'is_test_passed': isTestPassed
    });
  }

  Future<Either<BaseException, TransactionResult>> runTestIncrementTransactionOnTest({
    String testId,
    bool isTestPassed
  }) async {
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
      await test.value['total_tries']++;
      if (!isTestPassed) {
        await test.value['students_passed']++;
      }
      return test;
    });
    return Right(transactionResult);
  }

  Future<Either<BaseException, Map<String, dynamic>>> runUpdatePointsAndBestScore({String testId, int currentScore}) async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    final userId = _userRepository.user.uid;
    var userRef = _firebaseDatabase
        .reference()
        .child('users')
        .child(userId);
    var diff = 0;
    var transaction = await userRef.runTransaction((user) async {
      if (user == null) {
        return user;
      }
      if (user.value == null) {
        return user;
      }
      var test = user.value['tests_passed'].firstWhere((test) => test.keys.contains(testId) ? true : false);
      print(test.values.first['best_score']);
      var prevBestScore = test.values.first['best_score'];
      if (currentScore > prevBestScore) {
        diff = currentScore - prevBestScore;
        user.value['points'] += diff;
        test.values.first['best_score'] = currentScore;
      }

      return user;
    });
    return Right({
      'transaction_result': transaction,
      'diff': diff
    });
  }

  Future<Either<BaseException,TransactionResult>> runUpdateTestPoints(String testId, int diff) async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    var totalPointsRef = _firebaseDatabase
        .reference()
        .child('tests')
        .child(testId)
        .child('total_points');
    var transactionResult = await totalPointsRef.runTransaction((testPoints) async {
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