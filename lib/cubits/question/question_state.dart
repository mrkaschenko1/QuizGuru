part of 'question_cubit.dart';

enum QuestionStatus {question, finished, failure, initial, loading}

class QuestionState extends Equatable {
  final TestModel test;
  final int currentQuestionInd;
  final int currentScore;
  final String message;
  final QuestionStatus status;

  const QuestionState._({
    @required this.status,
    this.test,
    this.currentQuestionInd,
    @required this.currentScore,
    this.message
  });

  QuestionState.question({
    status: QuestionStatus.question,
    test,
    currentQuestionInd,
    currentQuestion,
    currentScore,
  }) : this._(
      status: status,
      test: test,
      currentQuestionInd: currentQuestionInd,
      currentScore: currentScore
  );

  QuestionState.endTest({
    status: QuestionStatus.finished,
    test,
    currentScore,
  }) : this._(
    status: status,
    test: test,
    currentScore: currentScore
  );

  QuestionState.failure({
    status: QuestionStatus.failure,
    test,
    currentQuestionInd,
    currentScore,
    message,
  }) : this._(
      status: status,
      test: test,
      currentQuestionInd: currentQuestionInd,
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
  }) : this._(status: status, currentScore: currentScore, test: test);

  @override
  List<Object> get props => [
    test,
    currentQuestionInd,
    currentScore,
    message
  ];
}
