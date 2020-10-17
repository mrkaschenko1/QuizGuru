import 'package:android_guru/blocs/lang/lang_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app_localizations.dart';
import 'injection_container.dart';
import 'ui/widgets/home_wrapper.dart';
import 'package:android_guru/blocs/theme/theme_bloc.dart';
import 'package:android_guru/ui/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'injection_container.dart' as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();
  await Firebase.initializeApp();
  di.init();
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
        BlocBuilder<LangBloc, LangState> (
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
