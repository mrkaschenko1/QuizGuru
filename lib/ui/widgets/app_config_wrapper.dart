// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// 🌎 Project imports:
import '../../app_localizations.dart';
import '../../injection_container.dart';
import '../../state_management/blocs/lang/lang_bloc.dart';
import '../../state_management/blocs/theme/theme_bloc.dart';
import '../screens/main_screen.dart';
import 'home_wrapper.dart';

class AppConfigWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (context) => sl.get<ThemeBloc>()),
        BlocProvider<LangBloc>(create: (context) => sl.get<LangBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeState) =>
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
        ),
      ),
    );
  }
}
