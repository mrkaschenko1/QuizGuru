import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit({@required this.repository}) : super(const TestState.loading());

  final TestRepository repository;

  Future<void> fetchList() async {
    try {
      final items = await repository.getTestsWithStatistics();
      emit(TestState.success(items));
    } on Exception {
      emit(const TestState.failure());
    }
  }
}
