// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

// 🌎 Project imports:
import 'app_localizations.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'messaging/functions.dart' as MessagingFunctions;
import 'state_management/blocs/lang/lang_bloc.dart';
import 'state_management/blocs/theme/theme_bloc.dart';
import 'ui/screens/main_screen.dart';
import 'ui/widgets/home_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  setLocalLocation(getLocation('Europe/Moscow'));
  HydratedBloc.storage = await HydratedStorage.build();
  await Firebase.initializeApp();
  di.init();
  final _firebaseMessaging = sl.get<FirebaseMessaging>();
  await _firebaseMessaging.subscribeToTopic('tests');
  _firebaseMessaging.configure(
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (context) => sl.get<ThemeBloc>()),
        BlocProvider<LangBloc>(create: (context) => sl.get<LangBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState themeState) =>
      BlocBuilder<LangBloc, LangState>(
        builder: (ctx, langState) => MaterialApp(
          title: 'Android Guru App',
          theme: themeState.themeData,
          routes: {
            HomeWrapper.routeName: (context) => HomeWrapper(),
            MainScreen.routeName: (context) => MainScreen(),
          },
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: langState.langData,
        ),
      );
}
