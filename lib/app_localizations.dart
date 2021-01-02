// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, dynamic> _localizedStrings;

  static const delegate = _AppLocalizationsDelegate();

  Future<bool> load(Locale locale) async {
    final jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    _localizedStrings = jsonMap.map<String, dynamic>(
        (String key, dynamic value) =>
            MapEntry<String, String>(key, value.toString()));

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] as String;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load(locale);
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
