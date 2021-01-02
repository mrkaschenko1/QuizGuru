// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/injection_container.dart';
import 'package:Quiz_Guru/ui/screens/auth_screen.dart';
import 'package:Quiz_Guru/ui/screens/main_screen.dart';

class HomeWrapper extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sl.get<FirebaseAuth>().authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (userSnapshot.hasData && userSnapshot.data != null) {
          return MainScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
