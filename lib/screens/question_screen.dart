import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:android_guru/screens/test_result_screen.dart';
import 'package:flutter/material.dart';

import '../injection_container.dart';


class QuestionScreen extends StatefulWidget {
  static const routeName = '/question';

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var _testRepository = sl.get<TestRepository>();

  var _test;
  var _questionNumber = 0;
  var _currentScore = 0;
  var _currentChoice = 0;
  var _answeredQuestions = new List();

  var _isLoading = false;
  var _isFinished = false;


    Future<void> fixResults() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var transactionMap = await _testRepository.runUpdatePointsAndBestScore(
          testId: _test.id,
          currentScore: _currentScore
      );

      var diff = 0;
      diff = transactionMap.fold((l) => null, (r) => diff = r['diff']);

      if (diff != 0) {
        await _testRepository.runUpdateTestPoints(_test.id, diff);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void goToResultScreen({int questionsLength, int currentScore}) async {
    await fixResults();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) =>
          TestResultScreen(
            questionsLength: questionsLength,
            totalScore: currentScore
          )
    ));
  }

  @override
  void didChangeDependencies() {
    if (_test == null) {
      _test = ModalRoute.of(context).settings.arguments;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _test = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _test.questions[_questionNumber];
    final width = MediaQuery.of(context).size.width;
    final widthForQuestion = width/_test.questions.length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: <Widget>[
          if (!_isLoading) IconButton(
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
                              goToResultScreen(questionsLength: _test.questions.length, currentScore: _currentScore);
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
                  width: _isFinished ? width : widthForQuestion*_questionNumber,
                  height: 10,
                ),
              ),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.6), boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0,0), blurRadius: 2)]),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
              child: Center(child: Text(currentQuestion['text'], style: TextStyle(fontSize: 18),)),
            ),
            Expanded(
              child: ListView(
                children: [
                  ...(currentQuestion['options'].asMap().map((optionIndex, option) {
                    return MapEntry(optionIndex, Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.6), boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0,0), blurRadius: 0)]),
                      child: RadioListTile(
                        dense: true,
                        title: Text(
                          option['text'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: (_currentChoice == optionIndex) ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        value: optionIndex,
                        groupValue: _currentChoice,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: (value) {
                          setState(() {
                            _currentChoice = value;
                          });
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
                child: _isLoading ?
                        Center(child: LinearProgressIndicator(backgroundColor: Theme.of(context).colorScheme.primaryVariant,),) :
                        Text(
                          _test.questions.length > _questionNumber+1 ?
                            AppLocalizations.of(context).translate('next_btn').toString().toUpperCase() :
                            AppLocalizations.of(context).translate('finish_quiz_btn').toString().toUpperCase(),
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 8),
                        ),
                onPressed: () {
                  print(_answeredQuestions);
                  if (currentQuestion['options'][_currentChoice]['right'] == true && !_answeredQuestions.contains(_questionNumber)) {
                    _currentScore += 1;
                    _answeredQuestions.add(_questionNumber);
                  }
                  _currentChoice = 0;
                  if (_test.questions.length == _questionNumber+1) {
                    setState(() {
                      _isFinished = true;
                    });
                    goToResultScreen(questionsLength: _test.questions.length, currentScore: _currentScore);
                  } else {
                    setState(() {
                    _questionNumber += 1;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
