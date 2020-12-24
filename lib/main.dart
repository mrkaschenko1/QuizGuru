// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

// 🌎 Project imports:
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'messaging/functions.dart' as MessagingFunctions;
import 'ui/widgets/app_config_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  setLocalLocation(getLocation('Europe/Moscow'));
  HydratedBloc.storage = await HydratedStorage.build();
  di.init();
  await Firebase.initializeApp();
  final _firebaseMessaging = sl.get<FirebaseMessaging>();
  await _firebaseMessaging.subscribeToTopic('tests');
  _configureFirebaseMessaging(_firebaseMessaging);
  runApp(AppConfigWrapper());
}

void _configureFirebaseMessaging(FirebaseMessaging messaging) async {
  messaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onBackgroundMessage: MessagingFunctions.myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );
  return;
}
