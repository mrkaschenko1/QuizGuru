// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/injection_container.dart' as di;
import 'package:Quiz_Guru/injection_container.dart';
import 'package:Quiz_Guru/messaging/functions.dart' as messaging_functions;
import 'package:Quiz_Guru/ui/widgets/app_config_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  setLocalLocation(getLocation('Europe/Moscow'));
  HydratedBloc.storage = await HydratedStorage.build();
  await Firebase.initializeApp();
  di.init();
  final _firebaseMessaging = sl.get<FirebaseMessaging>();
  await _firebaseMessaging.subscribeToTopic('tests');
  _configureFirebaseMessaging(_firebaseMessaging);
  runApp(AppConfigWrapper());
}

Future<void> _configureFirebaseMessaging(FirebaseMessaging messaging) async {
  messaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      // print("onMessage: $message");
    },
    onBackgroundMessage: messaging_functions.myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      // print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      // print("onResume: $message");
    },
  );
  return;
}
