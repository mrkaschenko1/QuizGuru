import 'package:android_guru/app_localizations.dart';

import '../../ui/widgets/home_wrapper.dart';
import 'package:flutter/material.dart';

class TestResultScreen extends StatelessWidget {

  final questionsLength;
  final totalScore;

  const TestResultScreen({@required this.questionsLength, @required this.totalScore});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
            Container(
              color: Theme.of(context).colorScheme.secondary,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: width, minHeight: 10),
              ),
            ),
          Expanded(child: Container(),),
          Container(
            color: Theme.of(context).cardColor.withOpacity(0.3),
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            margin: EdgeInsets.all(40),
            child: Column(
              children: <Widget>[
                Text('$totalScore/$questionsLength', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Theme.of(context).colorScheme.onSurface,
                ),
                ),
                Text(
                  AppLocalizations.of(context).translate('your_score').toString().toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onBackground,
                ),
                ),
              ],
            ),
          ),
          Expanded(child: Container(),),
          Container(
            height: Theme.of(context).buttonTheme.height,
            width: double.infinity,
            child: RaisedButton(
              color: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
              child: Text(AppLocalizations.of(context).translate('back_to_tests_btn').toString().toUpperCase(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 8),),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(HomeWrapper.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
