import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/cubits/question/question_cubit.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/ui/screens/test_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart';


// ignore: must_be_immutable
class QuestionScreen extends StatelessWidget {
  final TestModel test;
  var _currentChoice = 0;
  var _isFinished = false;

  QuestionScreen({Key key, this.test}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final widthForQuestion = width/test.questions.length;

    return BlocProvider(
      create: (_) => sl.get<QuestionCubit>()
      ..fetchTest(test),
      child: BlocConsumer<QuestionCubit, QuestionState>(
        builder: (context, state) =>
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              actions: <Widget>[
                if (state.status != QuestionStatus.loading) IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: Dialog(
                        elevation: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(AppLocalizations.of(context).translate('test_interrupt_dialog_question').toString()),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    AppLocalizations.of(context).translate('test_interrupt_dialog_continue').toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    AppLocalizations.of(context).translate('test_interrupt_dialog_finish').toString(),
                                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    BlocProvider.of<QuestionCubit>(context).finishTest(state.test.questions[state.currentQuestionInd].options[_currentChoice]);
                                },),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      color: Theme.of(context).colorScheme.secondary,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: _isFinished ? width : widthForQuestion*state.currentQuestionInd+1,
                        height: 10,
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.6), boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0,0), blurRadius: 2)]),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
                    child: Center(child: Text(state.test.questions[state.currentQuestionInd].text, style: TextStyle(fontSize: 18),)),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ...(state.test.questions[state.currentQuestionInd].options.asMap().map((optionIndex, option) {
                          return MapEntry(optionIndex, Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.6),
                                boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0,0), blurRadius: 0)]
                            ),
                            child: RadioListTile(
                              dense: true,
                              title: Text(
                                option.text,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: (_currentChoice == optionIndex) ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              value: optionIndex,
                              groupValue: _currentChoice,
                              activeColor: Theme.of(context).colorScheme.secondary,
                              onChanged: (value) {
//                                setState(() {
//                                  _currentChoice = value;
//                                });
                              },
                            ),
                          )
                          );
                        }).values.toList())
                      ]
                    ),
                  ),
                  Container(
                    height: Theme.of(context).buttonTheme.height,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.onSecondary,
                      child: state.status != QuestionStatus.loading ?
                              Center(child: LinearProgressIndicator(backgroundColor: Theme.of(context).colorScheme.primaryVariant,),) :
                              Text(
                                state.test.questions.length > state.currentQuestionInd+1 ?
                                  AppLocalizations.of(context).translate('next_btn').toString().toUpperCase() :
                                  AppLocalizations.of(context).translate('finish_quiz_btn').toString().toUpperCase(),
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 8),
                              ),
                      onPressed: () {
                        BlocProvider.of<QuestionCubit>(context).getNextQuestion(state.test.questions[state.currentQuestionInd].options[_currentChoice]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        listener: (context, state) {
          if (state.status == QuestionStatus.finished) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  TestResultScreen(
                    questionsLength: state.test.questions.length,
                    totalScore: state.currentScore
                  )
            ));
          } else if (state.status == QuestionStatus.failure) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
                SnackBar(backgroundColor: Colors.red, content: Text(state.message),)
            );
          }
        },
      ),
    );
  }
}

