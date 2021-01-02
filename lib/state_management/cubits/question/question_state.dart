part of 'question_cubit.dart';

enum QuestionStatus {
  question,
  finished,
  failure,
  initial,
  loading,
  changedChoice
}

class QuestionState extends Equatable {
  final TestModel test;
  final int currentQuestionInd;
  final int currentScore;
  final String message;
  final List<int> currentChoice;
  final QuestionStatus status;

  const QuestionState._(
      {@required this.status,
      this.test,
      this.currentQuestionInd,
      this.currentChoice,
      @required this.currentScore,
      this.message});

  const QuestionState.question({
    QuestionStatus status = QuestionStatus.question,
    TestModel test,
    List<int> currentChoice = const [0],
    int currentQuestionInd,
    int currentScore,
  }) : this._(
            status: status,
            test: test,
            currentChoice: currentChoice,
            currentQuestionInd: currentQuestionInd,
            currentScore: currentScore);

  const QuestionState.endTest({
    QuestionStatus status = QuestionStatus.finished,
    TestModel test,
    int currentScore,
    int currentQuestionInd,
  }) : this._(
            status: status,
            test: test,
            currentScore: currentScore,
            currentQuestionInd: currentQuestionInd);

  const QuestionState.failure({
    QuestionStatus status = QuestionStatus.failure,
    TestModel test,
    int currentQuestionInd,
    List<int> currentChoice,
    int currentScore,
    String message,
  }) : this._(
          status: status,
          test: test,
          currentQuestionInd: currentQuestionInd,
          currentChoice: currentChoice,
          currentScore: currentScore,
          message: message,
        );

  const QuestionState.initial({
    QuestionStatus status = QuestionStatus.initial,
    int currentScore = 0,
  }) : this._(status: status, currentScore: currentScore);

  const QuestionState.loading({
    QuestionStatus status = QuestionStatus.loading,
    TestModel test,
    int currentScore,
    List<int> currentChoice,
    int currentQuestionInd,
  }) : this._(
            status: status,
            currentScore: currentScore,
            test: test,
            currentChoice: currentChoice,
            currentQuestionInd: currentQuestionInd);

  const QuestionState.changedChoice({
    QuestionStatus status = QuestionStatus.changedChoice,
    int currentQuestionInd,
    int currentScore,
    List<int> currentChoice,
    TestModel test,
  }) : this._(
            status: status,
            currentQuestionInd: currentQuestionInd,
            currentScore: currentScore,
            currentChoice: currentChoice,
            test: test);

  @override
  List<Object> get props =>
      [status, test, currentQuestionInd, currentScore, currentChoice, message];
}
