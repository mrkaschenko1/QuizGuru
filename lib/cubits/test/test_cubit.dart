import 'package:android_guru/exceptions/network_exception.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit({@required this.repository}) : super(const TestState.loading());

  final TestRepository repository;

  Future<void> fetchTests() async {
    emit(TestState.loading());
    try {
      final tests = await repository.getTestsWithStatistics();
      tests.fold(
        (l) => throw NetworkException("No internet connection"),
        (r) => emit(TestState.success(r))
      );
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

      emit(TestState.success(startInProgress));

      var isTestPassed = false;
      var transactionMap = await repository.runTestsPassedTransactionOnTest(
          isTestPassed: isTestPassed,
          testId: id
      );

      transactionMap.fold(
        (l) => throw NetworkException("No internet connection"),
        (r) => isTestPassed = r['is_test_passed']
      );

    var transactionResult = await repository.runTestIncrementTransactionOnTest(isTestPassed: isTestPassed, testId: id);
    transactionResult.fold(
        (l) => throw NetworkException("No internet connection"),
        (r) => null
    );
    emit(TestState.started(state.tests.firstWhere((element) => id == element.id)));
  } on NetworkException catch (e) {
    emit(TestState.failure(e.message, tests: testsBeforeStart));
  }
  }
}
