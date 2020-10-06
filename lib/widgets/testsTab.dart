import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/widgets/test.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TestsTab extends StatelessWidget {
  final _fireBaseRef = FirebaseDatabase.instance.reference();

  Future<List<dynamic>> getTestWithStatistics() async {
      var tests = await _fireBaseRef
          .child('tests').once();

      var userTestsPassedInfo = await _fireBaseRef
          .child('users')
          .child(FirebaseAuth.instance.currentUser.uid)
          .child('tests_passed')
          .once();

      final result = [];

      await tests.value.forEach((key, value) {
        final testId = key;
        var userTries = 0;
        var bestScore = 0;
        try {
          var userExperience = userTestsPassedInfo.value.firstWhere((elem) {
            return elem.keys.first == testId;
          })[testId];
          userTries = userExperience['user_tries'];
          bestScore = userExperience['best_score'];
        } catch (e) {
        }
        result.add(TestModel(
            id: key,
            questions: value['questions'],
            studentsPassed: value['students_passed'],
            averageScore: value['average_score'],
            totalPoints: value['total_points'],
            title: value['title'],
            userTries: userTries,
            userBestScore: bestScore,
          )
        );
      });
      return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTestWithStatistics(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
//          print(futureSnapshot.data);
          return Center(
              child: CircularProgressIndicator()
          );
        } else if (futureSnapshot.data == null) {
          return Center(
            child: Text(
                StringUtils.capitalize(AppLocalizations.of(context).translate('no_quizzes_yet').toString())
            ),
          );
        } else {
          var tests = futureSnapshot.data;
          return ListView(
            children: <Widget>[
              ...tests.map((test) {
                return Test(
                  key: ValueKey(test.id),
                  test: test,
                );
              }
              ).toList()
            ],
          );
        }
      },
    );
  }
}
