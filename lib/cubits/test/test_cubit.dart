import 'package:android_guru/exceptions/network_exception.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/models/user_model.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit({@required this.testRepository, @required this.userRepository})
      : super(const TestState.loading());

  final TestRepository testRepository;
  final UserRepository userRepository;

  Future<void> fetchTests() async {
    emit(TestState.loading());
    try {
      final tests = await testRepository.getTestsWithStatistics();
      final user = await userRepository.getUserInfo();
      if (tests.isRight() && user.isRight()) {
        emit(TestState.success(
            tests.getOrElse(() => null), user.getOrElse(() => null)));
      } else {
        throw NetworkException("No internet connection");
      }
    } on NetworkException catch (e) {
      emit(TestState.failure(e.message, tests: state.tests));
    }
  }

  Future<void> startTest(String id) async {
    final testsBeforeStart = state.tests;
    try {
      final startInProgress = state.tests.map((test) {
        return test.id == id ? test.copyWith(isStarting: true) : test;
      }).toList();

      emit(TestState.success(startInProgress, state.user));

      var isTestPassed = false;
      var transactionMap = await testRepository.runTestsPassedTransactionOnTest(
          isTestPassed: isTestPassed, testId: id);

      transactionMap.fold(
          (l) => throw NetworkException("No internet connection"),
          (r) => isTestPassed = r['is_test_passed']);

      var transactionResult =
          await testRepository.runTestIncrementTransactionOnTest(
              isTestPassed: isTestPassed, testId: id);
      transactionResult.fold(
          (l) => throw NetworkException("No internet connection"), (r) => null);
      emit(TestState.started(
          state.tests.firstWhere((element) => id == element.id)));
    } on NetworkException catch (e) {
      emit(TestState.failure(e.message, tests: testsBeforeStart));
    }
  }
}
