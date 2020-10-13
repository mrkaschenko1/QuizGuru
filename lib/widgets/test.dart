import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/cubits/test/test_cubit.dart';
import 'package:android_guru/widgets/custom_expansion_tile.dart';
import 'package:android_guru/widgets/statistics_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Test extends StatefulWidget {
  final key;
  final test;

  Test({this.key, this.test,});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

//    Navigator.of(context)
//        .pushReplacementNamed(QuestionScreen.routeName, arguments: {
//      'testId': widget.test.id,
//      'questions': widget.test.questions,
//    });

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
              child: widget.test.isStarting
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
              onPressed: widget.test.isStarting ?
                  () {} :
                  () => BlocProvider.of<TestCubit>(context).startTest(widget.test.id),
            ),
          ),
        ],
      ),
    );
  }
}
