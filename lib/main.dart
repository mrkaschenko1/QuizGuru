import 'package:android_guru/global/lang/lang_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app_localizations.dart';
import 'widgets/home_wrapper.dart';
import 'package:android_guru/global/theme/theme_bloc.dart';
import 'package:android_guru/screens/question_screen.dart';
import 'package:android_guru/screens/tests_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        BlocProvider<LangBloc>(create: (context) => LangBloc(),),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );
    }

  Widget _buildWithTheme(BuildContext context, ThemeState themeState) =>
        BlocBuilder<LangBloc, LangState> (
          builder: (ctx, langState) => MaterialApp(
            title: 'Android Guru App',
            theme: themeState.themeData,
            routes: {
              HomeWrapper.routeName: (context) => HomeWrapper(),
              QuestionScreen.routeName: (context) => QuestionScreen(),
              TestsScreen.routeName: (context) => TestsScreen(),
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
