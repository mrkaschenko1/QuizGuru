import 'package:android_guru/ui/screens/tests_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../injection_container.dart';
import '../../ui/screens/auth_screen.dart';

class HomeWrapper extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: sl.get<FirebaseAuth>().authStateChanges(), builder: (ctx, userSnapshot) {
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
