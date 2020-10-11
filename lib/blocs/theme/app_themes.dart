import 'package:flutter/material.dart';

enum AppTheme {
  OrangeBrown,
  BlueGray,
}


final appThemeData = {
  AppTheme.OrangeBrown: getOrangeBrownTheme(),
  AppTheme.BlueGray: getBlueGrayTheme(),
};

Function getOrangeBrownTheme = () {
  final colorScheme = ColorScheme(
      primary: Color(0xffc9a185),
      primaryVariant: Color(0xffebd7ca),
      onPrimary: Color(0xff40514E),
      secondary: Color(0xffFFA45C),
      secondaryVariant: Color(0xffebd7ca),
      onSecondary: Colors.black,
      background: Color(0xff40514E),
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: Colors.blue,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.dark
  );
  return ThemeData(
    colorScheme: colorScheme,
    primaryColor: colorScheme.primary,
    primaryColorLight: colorScheme.primaryVariant,
    accentColor: colorScheme.secondary,
    scaffoldBackgroundColor: colorScheme.background,
    cardColor: Color(0xffd4d1c9),
    backgroundColor: Color(0xffb8b5ad),
    unselectedWidgetColor: Color(0x8840514E),
    textTheme: TextTheme(
      caption: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
};

Function getBlueGrayTheme = () {
  final colorScheme = ColorScheme(
      primary: Color(0xff6F7C7C),
      primaryVariant: Color(0xffebd7ca),
      onPrimary: Color(0xff40514E),
      secondary: Color(0xff29C5AF),
      secondaryVariant: Color(0xffebd7ca),
      onSecondary: Colors.black,
      background: Color(0xffE0E0E0),
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.blue,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.dark
  );
  return ThemeData(
    colorScheme: colorScheme,
    primaryColor: colorScheme.primary,
    primaryColorLight: colorScheme.primaryVariant,
    accentColor: colorScheme.secondary,
    scaffoldBackgroundColor: colorScheme.background,

    cardColor: Color(0xffE4E4E4),
    backgroundColor: Color(0xffb8b5ad),
    unselectedWidgetColor: Color(0x8840514E),
    textTheme: TextTheme(
      caption: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
};