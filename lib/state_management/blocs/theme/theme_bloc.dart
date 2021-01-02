// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/state_management/blocs/theme/app_themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(
          themeName: AppTheme.light,
          themeData: appThemeData[AppTheme.light],
        ));

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      yield ThemeState(
          themeName: event.theme, themeData: appThemeData[event.theme]);
    }
  }

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    final themeName = AppTheme.values[json['theme_index'] as int];
    return ThemeState(themeName: themeName, themeData: appThemeData[themeName]);
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) {
    return <String, int>{'theme_index': state.themeName.index};
  }
}
