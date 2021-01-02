// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/injection_container.dart';
import 'package:Quiz_Guru/models/option_model.dart';
import 'package:Quiz_Guru/models/question_model.dart';
import 'package:Quiz_Guru/models/test_model.dart';
import 'package:Quiz_Guru/state_management/cubits/question/question_cubit.dart';
import 'package:Quiz_Guru/ui/screens/test_result_screen.dart';
import 'package:Quiz_Guru/ui/widgets/interruption.dart';
import 'package:Quiz_Guru/ui/widgets/next_question_button.dart';
import 'package:Quiz_Guru/ui/widgets/question/multiple_variant.dart';
import 'package:Quiz_Guru/ui/widgets/question/one_variant.dart';

class QuestionScreen extends StatelessWidget {
  final TestModel test;

  const QuestionScreen({Key key, this.test}) : super(key: key);

  Widget _getVariantsWidget(QuestionState state) {
    final question = state.test.questions[state.currentQuestionInd];
    if (question.getQuestionType() == QuestionType.one) {
      return OneVariant(
        key: ValueKey<int>(state.currentQuestionInd),
        question: state.test.questions[state.currentQuestionInd],
      );
    } else {
      return MultipleVariant(
        key: ValueKey<int>(state.currentQuestionInd),
        question: state.test.questions[state.currentQuestionInd],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<QuestionCubit>(
      create: (_) => sl.get<QuestionCubit>()..fetchTest(test),
      child: BlocBuilder<QuestionCubit, QuestionState>(
          builder: (BuildContext context, QuestionState state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 20,
              bottom: 15,
            ),
            child: Column(
              children: <Widget>[
                Interruption(
                  state: state,
                ),
                Expanded(
                  child: BlocListener<QuestionCubit, QuestionState>(
                    listener: (BuildContext ctx, QuestionState state) {
                      if (state.status == QuestionStatus.finished) {
                        Navigator.of(ctx).pushReplacement<dynamic, dynamic>(
                            MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    TestResultScreen(
                                        questionsLength:
                                            state.test.questions.length,
                                        totalScore: state.currentScore)));
                      } else if (state.status == QuestionStatus.failure) {
                        Scaffold.of(ctx).removeCurrentSnackBar();
                        Scaffold.of(ctx).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(state.message),
                        ));
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              border: Border.all(
                                  width: 2, color: theme.accentColor),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: theme.accentColor,
                                  offset: const Offset(0, 2),
                                )
                              ]),
                          padding: const EdgeInsets.all(25),
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Center(
                              child: Text(
                            state.test.questions[state.currentQuestionInd].text,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: theme.accentColor),
                          )),
                        ),
                        Expanded(
                          child: _getVariantsWidget(state),
                        ),
                        NextQuestionButton(
                          theme: theme,
                          onPressedCallback: _onNextButtomPressed,
                          state: state,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _onNextButtomPressed(QuestionState state, BuildContext context) {
    final currentQuestion = state.test.questions[state.currentQuestionInd];
    final choices = <OptionModel>[];
    for (final choice in state.currentChoice) {
      choices.add(currentQuestion.options[choice]);
    }

    if (state.test.questions.length > state.currentQuestionInd + 1) {
      BlocProvider.of<QuestionCubit>(context).getNextQuestion(choices);
    } else {
      BlocProvider.of<QuestionCubit>(context).finishTest(choices);
    }
  }
}
