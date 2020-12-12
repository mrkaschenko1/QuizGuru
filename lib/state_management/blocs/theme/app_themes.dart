// Flutter imports:
import 'package:flutter/material.dart';

enum AppTheme {
  Light,
  Dark,
}

final appThemeData = {
  AppTheme.Light: getLightTheme(),
  AppTheme.Dark: getDarkTheme(),
};

Function getLightTheme = () {
  final colorScheme = ColorScheme(
      primary: Colors.white,
      primaryVariant: Color(0xffebd7ca),
      onPrimary: Color(0xff18191F),
      secondary: Color(0xff18191F),
      secondaryVariant: Color(0xff18191F),
      onSecondary: Colors.white,
      background: Colors.white,
      onBackground: Color(0xff18191F),
      surface: Color(0xFFFE9D81),
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.light);
  return ThemeData(
    fontFamily: 'Montserrat',
    colorScheme: colorScheme,
    primaryColor: colorScheme.primary,
    primaryColorLight: colorScheme.primaryVariant,
    accentColor: colorScheme.secondary,
    scaffoldBackgroundColor: colorScheme.background,
    cardColor: Colors.white,
    backgroundColor: colorScheme.background,
    unselectedWidgetColor: Color(0xFF656565),
    textTheme: TextTheme(
      caption: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
};

Function getDarkTheme = () {
  final colorScheme = ColorScheme(
      primary: Color(0xff18191F),
      primaryVariant: Color(0xff18191F),
      onPrimary: Colors.white,
      secondary: Color(0xffe6e3e3),
      secondaryVariant: Colors.white,
      onSecondary: Color(0xff18191F),
      background: Color(0xff18191F),
      onBackground: Colors.white,
      surface: Color(0xFFFE9D81),
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.dark);
  return ThemeData(
    fontFamily: 'Montserrat',
    colorScheme: colorScheme,
    primaryColor: colorScheme.primary,
    primaryColorLight: colorScheme.primaryVariant,
    accentColor: colorScheme.secondary,
    scaffoldBackgroundColor: colorScheme.background,
    cardColor: Color(0xff202129),
    backgroundColor: colorScheme.background,
    unselectedWidgetColor: Color(0xFF656565),
    textTheme: TextTheme(
      caption: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
};
