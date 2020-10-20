part of 'question_cubit.dart';

enum QuestionStatus {question, finished, failure, initial, loading, changedChoice}

class QuestionState extends Equatable {
  final TestModel test;
  final int currentQuestionInd;
  final int currentScore;
  final String message;
  final int currentChoice;
  final QuestionStatus status;

  const QuestionState._({
    @required this.status,
    this.test,
    this.currentQuestionInd,
    this.currentChoice,
    @required this.currentScore,
    this.message
  });

  QuestionState.question({
    status: QuestionStatus.question,
    test,
    currentChoice = 0,
    currentQuestionInd,
    currentQuestion,
    currentScore,
  }) : this._(
      status: status,
      test: test,
      currentChoice: currentChoice,
      currentQuestionInd: currentQuestionInd,
      currentScore: currentScore
  );

  QuestionState.endTest({
    status: QuestionStatus.finished,
    test,
    currentScore,
    currentQuestionInd,
  }) : this._(
    status: status,
    test: test,
    currentScore: currentScore,
    currentQuestionInd: currentQuestionInd
  );

  QuestionState.failure({
    status: QuestionStatus.failure,
    test,
    currentQuestionInd,
    currentChoice,
    currentScore,
    message,
  }) : this._(
      status: status,
      test: test,
      currentQuestionInd: currentQuestionInd,
      currentChoice: currentChoice,
      currentScore: currentScore,
      message: message,
  );

  QuestionState.initial({
    status: QuestionStatus.initial,
    currentScore: 0,
  }) : this._(status: status, currentScore: currentScore);

  QuestionState.loading({
    status: QuestionStatus.loading,
    test,
    currentScore,
    currentChoice,
    currentQuestionInd,
  }) : this._(
      status: status,
      currentScore: currentScore,
      test: test,
      currentChoice: currentChoice,
      currentQuestionInd: currentQuestionInd
  );

  QuestionState.changedChoice({
    status: QuestionStatus.changedChoice,
    currentQuestionInd,
    currentScore,
    currentChoice,
    test,
  }) : this._(
      status: status,
      currentQuestionInd: currentQuestionInd,
      currentScore: currentScore,
      currentChoice: currentChoice,
      test: test
  );

  @override
  List<Object> get props => [
    status,
    test,
    currentQuestionInd,
    currentScore,
    currentChoice,
    message
  ];
}
