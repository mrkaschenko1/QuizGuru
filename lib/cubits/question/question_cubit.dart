import 'package:android_guru/exceptions/network_exception.dart';
import 'package:android_guru/models/option_model.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit({@required this.repository}) : super(QuestionState.initial());

  final TestRepository repository;

  void fetchTest(TestModel test) {
    emit(QuestionState.question(test: test, currentQuestionInd: 0, currentScore: 0));
  }

  void getNextQuestion(OptionModel selectedOption) async {
    print(state.currentScore);
    var newScore = selectedOption.isRight ? (state.currentScore + 1) : state.currentScore;
    emit(
        QuestionState.question(
          test: state.test,
          currentQuestionInd: state.currentQuestionInd+1,
          currentScore: newScore
        )
    );
  }

  void showSelectedChoice(int value) {
    emit(
      QuestionState.changedChoice(
          currentQuestionInd: state.currentQuestionInd,
          currentScore: state.currentScore,
          currentChoice: value,
          test: state.test
      )
    );
  }

  void finishTest(OptionModel selectedOption) async {
    var newScore = selectedOption.isRight ? (state.currentScore + 1) : state.currentScore;
    final test = state.test;
    emit(QuestionState.loading(
        currentQuestionInd: state.currentQuestionInd,
        currentScore: state.currentScore,
        test: state.test,
        currentChoice: state.currentChoice
      )
    );

    try {
      var transactionMap = await repository.runUpdatePointsAndBestScore(
          testId: state.test.id,
          currentScore: newScore
      );

      var diff = 0;

      transactionMap.fold(
          (l) => throw NetworkException(l.message),
          (r) => {diff = r['diff']}
      );

      if (diff != 0) {
        var result = await repository.runUpdateTestPoints(state.test.id, diff);
        result.fold(
          (l) => throw NetworkException(l.message),
          (r) => null
        );
      }
      emit(QuestionState.endTest(
          currentScore: newScore,
          test: test,
          currentQuestionInd: state.currentQuestionInd
      ));
      } on NetworkException catch (e) {
      emit(QuestionState.failure(
          test: test,
          currentQuestionInd: test.questions.length-1,
          currentChoice: 0,
          currentScore: state.currentScore,
          message: e.message
      ));
    }
  }
}
