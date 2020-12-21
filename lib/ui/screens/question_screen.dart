// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../injection_container.dart';
import '../../models/option_model.dart';
import '../../models/question_model.dart';
import '../../models/test_model.dart';
import '../../state_management/cubits/question/question_cubit.dart';
import '../../ui/screens/test_result_screen.dart';
import '../../ui/widgets/interruption.dart';
import '../../ui/widgets/next_question_button.dart';
import '../../ui/widgets/question/multiple_variant.dart';
import '../../ui/widgets/question/one_variant.dart';

class QuestionScreen extends StatelessWidget {
  final TestModel test;

  QuestionScreen({Key key, this.test}) : super(key: key);

  Widget _getVariantsWidget(QuestionState state) {
    final question = state.test.questions[state.currentQuestionInd];
    if (question.getQuestionType() == QuestionType.One) {
      return OneVariant(
        key: ValueKey(state.currentQuestionInd),
        question: state.test.questions[state.currentQuestionInd],
      );
    } else {
      return MultipleVariant(
        key: ValueKey(state.currentQuestionInd),
        question: state.test.questions[state.currentQuestionInd],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => sl.get<QuestionCubit>()..fetchTest(test),
      child:
          BlocBuilder<QuestionCubit, QuestionState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 15),
            child: Column(
              children: <Widget>[
                Interruption(
                  state: state,
                ),
                Expanded(
                  child: BlocListener<QuestionCubit, QuestionState>(
                    listener: (ctx, state) {
                      if (state.status == QuestionStatus.finished) {
                        Navigator.of(ctx).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => TestResultScreen(
                                questionsLength: state.test.questions.length,
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
                                  BorderRadius.all(Radius.circular(16)),
                              border: Border.all(
                                  width: 2, color: theme.accentColor),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.accentColor,
                                  offset: Offset(0, 2),
                                )
                              ]),
                          padding: EdgeInsets.all(25),
                          margin: EdgeInsets.only(top: 20, bottom: 20),
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

  _onNextButtomPressed(QuestionState state, BuildContext context) {
    QuestionModel currentQuestion =
        state.test.questions[state.currentQuestionInd];
    List<OptionModel> choices = [];
    for (int choice in state.currentChoice) {
      choices.add(currentQuestion.options[choice]);
    }

    if (state.test.questions.length > state.currentQuestionInd + 1) {
      BlocProvider.of<QuestionCubit>(context).getNextQuestion(choices);
    } else {
      BlocProvider.of<QuestionCubit>(context).finishTest(choices);
    }
  }
}
