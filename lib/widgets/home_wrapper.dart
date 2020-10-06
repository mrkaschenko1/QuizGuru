import 'package:android_guru/screens/tests_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth_screen.dart';

class HomeWrapper extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx, userSnapshot) {
      print(userSnapshot.data);
      if (userSnapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (userSnapshot.hasData && userSnapshot.data != null) {
        return TestsScreen();
      } else {
        return AuthScreen();
      }
    },);
  }
}
