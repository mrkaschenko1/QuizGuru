import 'package:android_guru/app_localizations.dart';

import '../../ui/widgets/home_wrapper.dart';
import 'package:flutter/material.dart';

class TestResultScreen extends StatelessWidget {
  final questionsLength;
  final totalScore;

  const TestResultScreen(
      {@required this.questionsLength, @required this.totalScore});

  String _getImageAsset(double result) {
    if (result >= 0.85) {
      return 'assets/images/doodles/happy_person.png';
    } else if (result >= 0.70) {
      return 'assets/images/doodles/neutral_person.png';
    }
    return 'assets/images/doodles/sad_person.png';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double result = totalScore / questionsLength;
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(40),
              margin: EdgeInsets.only(left: 40, right: 40),
              decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  border: Border.all(width: 2, color: theme.accentColor),
                  boxShadow: [
                    BoxShadow(
                      color: theme.accentColor,
                      offset: Offset(0, 2),
                    )
                  ]),
              child: Column(
                children: <Widget>[
                  Text(
                    '$totalScore/$questionsLength',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 50,
                      color: theme.accentColor,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('your_score')
                        .toString()
                        .toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: theme.accentColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              height: 250,
              child: Image.asset(
                _getImageAsset(result),
                fit: BoxFit.scaleDown,
                alignment: Alignment.topCenter,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    color: theme.accentColor,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('back_to_tests_btn')
                          .toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: theme.primaryColor),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(HomeWrapper.routeName);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
