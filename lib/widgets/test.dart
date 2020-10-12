import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:android_guru/screens/question_screen.dart';
import 'package:android_guru/widgets/custom_expansion_tile.dart';
import 'package:android_guru/widgets/statistics_info_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  final key;
  final test;

  Test({this.key, this.test,});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  var _isLoading = false;
  static final _firebaseDatabase = FirebaseDatabase();
  var _testRepository = TestRepository(userRepository: UserRepository(), firebaseDatabase: _firebaseDatabase);

  void startTest(String testId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var isTestPassed = false;
      var transactionMap = await TestRepository()
          .runTestsPassedTransactionOnTest(
            isTestPassed: isTestPassed,
            testId: testId
          );
      isTestPassed = transactionMap['is_test_passed'];

      await _testRepository.runTestIncrementTransactionOnTest(isTestPassed: isTestPassed, testId: widget.test.id);

    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(e.toString()),
      ));
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context)
        .pushReplacementNamed(QuestionScreen.routeName, arguments: {
      'testId': widget.test.id,
      'questions': widget.test.questions,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
        const BoxShadow(
            color: Colors.grey, offset: Offset(1, 0), blurRadius: 2),
        const BoxShadow(
            color: Colors.grey, offset: Offset(-1, 0), blurRadius: 2)
      ]),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: CustomExpansionTile(
              title: Text(
                widget.test.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.justify,
              ),
              children: [
                Container(
                    color: Theme.of(context).backgroundColor,
                    padding: const EdgeInsets.all(10),
                    child: Column(children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            StatisticsInfoCard(
                                title: AppLocalizations.of(context)
                                    .translate('questions')
                                    .toString(),
                                value: widget.test.questions.length),
                            StatisticsInfoCard(
                                title: AppLocalizations.of(context)
                                    .translate('students_passed')
                                    .toString(),
                                value: widget.test.studentsPassed),
                            StatisticsInfoCard(
                                title: AppLocalizations.of(context)
                                    .translate('average_score')
                                    .toString(),
                                value: (widget.test.studentsPassed != 0)
                                    ? (widget.test.totalPoints /
                                            widget.test.studentsPassed)
                                        .toStringAsFixed(2)
                                    : 0),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StatisticsInfoCard(
                              title: AppLocalizations.of(context)
                                  .translate('user_tries')
                                  .toString(),
                              value: widget.test.userTries),
                          StatisticsInfoCard(
                              title: AppLocalizations.of(context)
                                  .translate('best_score')
                                  .toString(),
                              value: widget.test.userBestScore),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: Theme.of(context).buttonTheme.height,
            width: double.infinity,
            child: RaisedButton(
              color: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
              child: _isLoading
                  ? LinearProgressIndicator(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryVariant,
                    )
                  : Text(
                      AppLocalizations.of(context)
                          .translate('start_quiz_btn')
                          .toString()
                          .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 8,
                      ),
                    ),
              onPressed: _isLoading ? () {} : () => startTest(widget.test.id),
            ),
          ),
        ],
      ),
    );
  }
}
