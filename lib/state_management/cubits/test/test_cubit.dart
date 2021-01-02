// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/exceptions/network_exception.dart';
import 'package:Quiz_Guru/models/test_model.dart';
import 'package:Quiz_Guru/models/user_model.dart';
import 'package:Quiz_Guru/repositories/test_repository.dart';
import 'package:Quiz_Guru/repositories/user_repository.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit({@required this.testRepository, @required this.userRepository})
      : super(const TestState.loading());

  final TestRepository testRepository;
  final UserRepository userRepository;

  Future<void> fetchTests() async {
    emit(const TestState.loading());
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
      final transactionMap =
          await testRepository.runTestsPassedTransactionOnTest(testId: id);

      transactionMap.fold(
          (l) => throw NetworkException("No internet connection"),
          (r) => isTestPassed = r['is_test_passed'] as bool);

      final transactionResult =
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
