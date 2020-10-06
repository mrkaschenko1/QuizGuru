import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/screens/question_screen.dart';
import 'package:android_guru/widgets/custom_expansion_tile.dart';
import 'package:android_guru/widgets/statistics_info_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var _userId = FirebaseAuth.instance.currentUser.uid;

  Future<Map<String, dynamic>> runTestsPassedTransaction(
      DatabaseReference ref, bool isTestPassed) async {
    final transactionResult = await ref.runTransaction((userTest) async {
      if (userTest == null) {
        return userTest;
      }
      if (userTest.value == null) {
        return userTest;
      }
      if (!userTest.value.containsKey('tests_passed')) {
        print('making tests_passed list');
        userTest.value['tests_passed'] = List<dynamic>();
      }
      if (!userTest.value['tests_passed']
          .any((e) => e.keys.contains(widget.test.id) ? true : false)) {
        print('we don\'t have our test in user list');
        var testsPassed =
            List.of(userTest.value['tests_passed'], growable: true);
        testsPassed.add({
          widget.test.id: {
            'user_tries': 1,
            'best_score': 0,
          }
        });
        userTest.value['tests_passed'] = testsPassed;
      } else {
        print('we have our test in list');
        isTestPassed = true;
        var index = userTest.value['tests_passed']
            .indexWhere((e) => e.keys.contains(widget.test.id) ? true : false);
        await userTest.value['tests_passed'][index][widget.test.id]
            ['user_tries']++;
      }
      return userTest;
    });
    return {
      'transaction_result': transactionResult,
      'is_test_passed': isTestPassed
    };
  }

  Future<TransactionResult> runTestIncrementTransaction(
      DatabaseReference ref, bool isTestPassed) async {
    return await ref.runTransaction((test) async {
      if (test == null) {
        return test;
      }
      await test.value['total_tries']++;
      if (!isTestPassed) {
        await test.value['students_passed']++;
      }
      return test;
    });
  }

  void startTest() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var isTestPassed = false;
      final firebaseRef = FirebaseDatabase.instance.reference();
      final user = firebaseRef.child('users').child(_userId);
      var transactionMap = await runTestsPassedTransaction(user, isTestPassed);
      isTestPassed = transactionMap['is_test_passed'];

      final test = firebaseRef.child('tests').child(widget.test.id);
      await runTestIncrementTransaction(test, isTestPassed);

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
              onPressed: _isLoading ? () {} : startTest,
            ),
          ),
        ],
      ),
    );
  }
}
