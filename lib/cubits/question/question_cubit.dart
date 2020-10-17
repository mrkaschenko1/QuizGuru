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
    var newScore = selectedOption.isRight ? (state.currentScore + 1) : state.currentScore;
    emit(
        QuestionState.question(
          test: state.test,
          currentQuestionInd: state.currentQuestionInd+1,
          currentScore: newScore
        )
    );
  }

  void finishTest(OptionModel selectedOption) async {
    var newScore = selectedOption.isRight ? (state.currentScore + 1) : state.currentScore;
    emit(QuestionState.endTest(currentScore: newScore));

    try {
      var transactionMap = await repository.runUpdatePointsAndBestScore(
          testId: state.test.id,
          currentScore: newScore
      );

      var diff = 0;

      transactionMap.fold(
          (l) => emit(QuestionState.failure(
              test: state.test,
              currentQuestionInd: state.currentQuestionInd,
              currentScore: state.currentScore,
              message: transactionMap.leftMap((l) => l.message)
          )),
          (r) => {diff = r['diff']}
      );
      if (transactionMap.isLeft()) {
        return;
      }

      if (diff != 0) {
        var result = await repository.runUpdateTestPoints(state.test.id, diff);
        result.fold(
          (l) => emit(QuestionState.failure(
              test: state.test,
              currentQuestionInd: state.currentQuestionInd,
              currentScore: state.currentScore,
              message: l.message)
          ),
          (r) => null
        );
        if (result.isLeft()) {
          return;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
