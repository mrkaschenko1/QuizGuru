import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/network/network_info.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:android_guru/widgets/test.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TestsTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TestRepository(userRepository: UserRepository(
                firebaseAuth: FirebaseAuth.instance,
                googleSignIn: GoogleSignIn(),
                firebaseDatabase: FirebaseDatabase.instance,
                networkInfo: NetworkInfoImpl(DataConnectionChecker())
              ),
              firebaseDatabase: FirebaseDatabase(),
              networkInfo: NetworkInfoImpl(DataConnectionChecker()
            )
      ).getTestsWithStatistics(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
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
