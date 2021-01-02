// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/exceptions/network_exception.dart';
import 'package:Quiz_Guru/models/option_model.dart';
import 'package:Quiz_Guru/models/test_model.dart';
import 'package:Quiz_Guru/repositories/test_repository.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit({@required this.repository})
      : super(const QuestionState.initial());

  final TestRepository repository;

  void fetchTest(TestModel test) {
    emit(QuestionState.question(
        test: test, currentQuestionInd: 0, currentScore: 0));
  }

  bool _isRight(
      {@required List<OptionModel> selected,
      @required List<OptionModel> right}) {
    final Function eq = const DeepCollectionEquality.unordered().equals;
    return eq(selected, right) as bool;
  }

  Future<void> getNextQuestion(List<OptionModel> selectedOptions) async {
    final questionId = state.currentQuestionInd;
    final List<OptionModel> options = state.test.questions[questionId].options;
    final List<OptionModel> rightOptions =
        options.where((element) => element.isRight).toList();

    final newScore = _isRight(right: rightOptions, selected: selectedOptions)
        ? (state.currentScore + 1)
        : state.currentScore;
    // print('new score is $newScore');
    emit(QuestionState.question(
        test: state.test,
        currentQuestionInd: state.currentQuestionInd + 1,
        currentScore: newScore));
  }

  void showSelectedChoice(List<int> value) {
    // print('selected choice $value');
    emit(QuestionState.changedChoice(
        currentQuestionInd: state.currentQuestionInd,
        currentScore: state.currentScore,
        currentChoice: value,
        test: state.test));
  }

  void addOrRemoveToChoice(int value) {
    final List<int> newChoiceList = <int>[...state.currentChoice];
    if (state.currentChoice.contains(value)) {
      newChoiceList.remove(value);
    } else {
      newChoiceList.add(value);
    }
    // print('selected choice $newChoiceList');
    emit(QuestionState.changedChoice(
        currentQuestionInd: state.currentQuestionInd,
        currentScore: state.currentScore,
        currentChoice: newChoiceList,
        test: state.test));
  }

  Future<void> finishTest(List<OptionModel> selectedOptions) async {
    final test = state.test;
    final questionId = state.currentQuestionInd;
    int newScore;

    if (selectedOptions != null) {
      final List<OptionModel> options = test.questions[questionId].options;
      final List<OptionModel> rightOptions =
          options.where((element) => element.isRight).toList();

      newScore = _isRight(right: rightOptions, selected: selectedOptions)
          ? (state.currentScore + 1)
          : state.currentScore;
    } else {
      newScore = state.currentScore;
    }

    emit(QuestionState.loading(
        currentQuestionInd: state.currentQuestionInd,
        currentScore: state.currentScore,
        test: state.test,
        currentChoice: state.currentChoice));

    try {
      final transactionMap = await repository.runUpdatePointsAndBestScore(
          testId: state.test.id, currentScore: newScore);

      var diff = 0;

      transactionMap.fold((l) => throw NetworkException(l.message),
          (r) => diff = r['diff'] as int);

      if (diff != 0) {
        final result =
            await repository.runUpdateTestPoints(state.test.id, diff);
        result.fold((l) => throw NetworkException(l.message), (r) => null);
      }
      emit(QuestionState.endTest(
          currentScore: newScore,
          test: test,
          currentQuestionInd: state.currentQuestionInd));
    } on NetworkException catch (e) {
      emit(QuestionState.failure(
          test: test,
          currentQuestionInd: test.questions.length - 1,
          currentChoice: const [0],
          currentScore: state.currentScore,
          message: e.message));
    }
  }
}
