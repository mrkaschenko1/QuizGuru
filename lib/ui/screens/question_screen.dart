import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/cubits/question/question_cubit.dart';
import 'package:android_guru/models/option_model.dart';
import 'package:android_guru/models/question_model.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/ui/screens/test_result_screen.dart';
import 'package:android_guru/ui/widgets/interruption.dart';
import 'package:android_guru/ui/widgets/question/multiple_variant.dart';
import 'package:android_guru/ui/widgets/question/one_variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../injection_container.dart';

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
    final width = MediaQuery.of(context).size.width;
    final widthForQuestion =
        test != null ? width / test.questions.length : width;
    return BlocProvider(
      create: (_) => sl.get<QuestionCubit>()..fetchTest(test),
      child:
          BlocBuilder<QuestionCubit, QuestionState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
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
                      // Container(
                      //   color: Theme.of(context).colorScheme.secondary,
                      //   child: AnimatedContainer(
                      //     duration: Duration(milliseconds: 200),
                      //     width:
                      //         widthForQuestion * state.currentQuestionInd + 1,
                      //     height: 10,
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.6),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 0),
                                  blurRadius: 2)
                            ]),
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(
                            right: 20, left: 20, top: 20, bottom: 40),
                        child: Center(
                            child: Text(
                          state.test.questions[state.currentQuestionInd].text,
                          style: TextStyle(fontSize: 18),
                        )),
                      ),
                      Expanded(
                        child: _getVariantsWidget(state),
                      ),
                      Container(
                        height: Theme.of(context).buttonTheme.height,
                        width: double.infinity,
                        child: FlatButton(
                          color: Colors.black,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          child: state.status == QuestionStatus.loading
                              ? Center(
                                  child: LinearProgressIndicator(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      state.test.questions.length >
                                              state.currentQuestionInd + 1
                                          ? AppLocalizations.of(context)
                                              .translate('next_btn')
                                              .toString()
                                          : AppLocalizations.of(context)
                                              .translate('finish_quiz_btn')
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    Icon(
                                      FeatherIcons.chevronRight,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                          onPressed: () {
                            QuestionModel currentQuestion =
                                state.test.questions[state.currentQuestionInd];
                            List<OptionModel> choices = [];
                            for (int choice in state.currentChoice) {
                              choices.add(currentQuestion.options[choice]);
                            }

                            if (state.test.questions.length >
                                state.currentQuestionInd + 1) {
                              BlocProvider.of<QuestionCubit>(context)
                                  .getNextQuestion(choices);
                            } else {
                              BlocProvider.of<QuestionCubit>(context)
                                  .finishTest(choices);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
