import 'package:android_guru/exceptions/network_exception.dart';
import 'package:android_guru/models/option_model.dart';
import 'package:android_guru/models/question_model.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit({@required this.repository}) : super(QuestionState.initial());

  final TestRepository repository;

  void fetchTest(TestModel test) {
    emit(QuestionState.question(
        test: test, currentQuestionInd: 0, currentScore: 0));
  }

  bool _isRight(
      {@required List<OptionModel> selected,
      @required List<OptionModel> right}) {
    Function eq = const DeepCollectionEquality.unordered().equals;
    return eq(selected, right);
  }

  void getNextQuestion(List<OptionModel> selectedOptions) async {
    final questionId = state.currentQuestionInd;
    final List<OptionModel> options = state.test.questions[questionId].options;
    final List<OptionModel> rightOptions =
        options.where((element) => element.isRight).toList();

    var newScore = _isRight(right: rightOptions, selected: selectedOptions)
        ? (state.currentScore + 1)
        : state.currentScore;
    print('new score is $newScore');
    emit(QuestionState.question(
        test: state.test,
        currentQuestionInd: state.currentQuestionInd + 1,
        currentScore: newScore));
  }

  void showSelectedChoice(List<int> value) {
    print('selected choice $value');
    emit(QuestionState.changedChoice(
        currentQuestionInd: state.currentQuestionInd,
        currentScore: state.currentScore,
        currentChoice: value,
        test: state.test));
  }

  void finishTest(List<OptionModel> selectedOptions) async {
    final test = state.test;
    final questionId = state.currentQuestionInd;
    var newScore;

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
      var transactionMap = await repository.runUpdatePointsAndBestScore(
          testId: state.test.id, currentScore: newScore);

      var diff = 0;

      transactionMap.fold(
          (l) => throw NetworkException(l.message), (r) => {diff = r['diff']});

      if (diff != 0) {
        var result = await repository.runUpdateTestPoints(state.test.id, diff);
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
          currentChoice: 0,
          currentScore: state.currentScore,
          message: e.message));
    }
  }
}
