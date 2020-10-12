import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:firebase_database/firebase_database.dart';

class TestRepository {
  final UserRepository _userRepository;
  final FirebaseDatabase _firebaseDatabase;

  TestRepository({UserRepository userRepository, FirebaseDatabase firebaseDatabase})
      :
        _userRepository = userRepository ?? UserRepository(),
        _firebaseDatabase = firebaseDatabase ?? FirebaseDatabase.instance;


  Future<List<dynamic>> getTestsWithStatistics() async {
    var tests = await _firebaseDatabase
        .reference()
        .child('tests').once();

    var userTestsPassedInfo = await _firebaseDatabase
        .reference()
        .child('users')
        .child(_userRepository.user.uid)
        .child('tests_passed')
        .once();

    final result = [];

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
        questions: value['questions'],
        studentsPassed: value['students_passed'],
        averageScore: value['average_score'],
        totalPoints: value['total_points'],
        title: value['title'],
        userTries: userTries,
        userBestScore: bestScore,
      )
      );
    });
    return result;
  }

  //runs before test starts
  Future<Map<String, dynamic>> runTestsPassedTransactionOnTest({bool isTestPassed, String testId}) async {
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
    return {
      'transaction_result': transactionResult,
      'is_test_passed': isTestPassed
    };
  }

  Future<TransactionResult> runTestIncrementTransactionOnTest({
    String testId,
    bool isTestPassed
  }) async {
    return await _firebaseDatabase
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
  }
}