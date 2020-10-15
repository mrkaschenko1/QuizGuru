import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/models/user_model.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:android_guru/widgets/statistics_info_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../injection_container.dart';

class UserTab extends StatelessWidget {
  Future<Object> getUserInfo() async {
    var fireBaseRef = sl.get<FirebaseDatabase>().reference();
    var currentUser = await fireBaseRef.child('users').child(FirebaseAuth.instance.currentUser.uid).once();
    var currentUserPoints = currentUser.value['points'];
    var usersBetter = await fireBaseRef.child('users').orderByChild('points').startAt(currentUserPoints+1).once();

    var userRating;
    if (usersBetter.value == null) {
      userRating = 1;
    } else {
      userRating = usersBetter.value.length+1;
    }

    var testsCount;
    if (!currentUser.value.containsKey('tests_passed'))  {
      testsCount = 0;
    } else {
      testsCount = currentUser.value['tests_passed'].length;
    }

    return UserModel(
      id: sl.get<UserRepository>().user.uid,
      username: currentUser.value['username'],
      email: currentUser.value['email'],
      testsPassedCount: testsCount,
      ratingPosition: userRating
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserInfo(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(),);
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  boxShadow: [const BoxShadow(color: Colors.grey)]
                ),
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('profile_info').toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                      ),
                      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 15),
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
                      child: Text(
                          '${AppLocalizations.of(context).translate('login').toString()}: ${snapshot.data['username']}',
                          style: const TextStyle(fontSize: 18, color: Colors.black87)
                      )
                    ),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                        ),
                        margin: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
                        child: Text(
                            '${AppLocalizations.of(context).translate('email').toString()}: ${snapshot.data['email']}',
                            style: const TextStyle(fontSize: 18, color: Colors.black87)
                        )
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  boxShadow: [const BoxShadow(color: Colors.grey)],
                ),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('statistics').toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(children: <Widget>[
                          StatisticsInfoCard(title: AppLocalizations.of(context).translate('points').toString(), value: snapshot.data['points'],),
                          StatisticsInfoCard(title: AppLocalizations.of(context).translate('tests_passed').toString(), value: snapshot.data['tests_count'],),
                          StatisticsInfoCard(title: AppLocalizations.of(context).translate('position').toString(), value: snapshot.data['rating'],),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
