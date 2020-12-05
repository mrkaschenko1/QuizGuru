import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/cubits/test/test_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'file:///C:/Users/AndreyKas/AndroidStudioProjects/android_guru/lib/ui/widgets/custom_expansion_tile.dart';
import 'file:///C:/Users/AndreyKas/AndroidStudioProjects/android_guru/lib/ui/widgets/statistics_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charcode/html_entity.dart';

class Test extends StatefulWidget {
  final key;
  final test;

  Test({this.key, this.test,});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

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
                  maxLines: 2,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
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
                              value: '${widget.test.userTries}/${widget.test.tries ?? String.fromCharCode($infin)}'
                          ),
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
                  : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text((widget.test.userTries ?? 0) >= (widget.test.tries ?? double.infinity)
                      ? AppLocalizations.of(context)
                            .translate('no_more_attempts')
                            .toString()
                            .toUpperCase()
                      : AppLocalizations.of(context)
                            .translate('start_quiz_btn')
                            .toString()
                            .toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 8,
                        ),
                      ),
                  ),
              onPressed: (widget.test.isStarting || (widget.test.userTries ?? 0) >= (widget.test.tries ?? double.infinity)) ?
                  () {} :
                  () => BlocProvider.of<TestCubit>(context).startTest(widget.test.id),
            ),
          ),
        ],
      ),
    );
  }
}
