import 'dart:async';
import 'dart:ui';

import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/global/lang/app_langs.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'lang_event.dart';
part 'lang_state.dart';

class LangBloc extends HydratedBloc<LangEvent, LangState> {
  LangBloc() : super(LangState(langData: appLangData[AppLang.EN]));

  @override
  Stream<LangState> mapEventToState(
    LangEvent event,
  ) async* {
    if (event is LangChanged) {
      AppLocalizations.delegate.load(appLangData[event.lang]);
      yield LangState(langData: appLangData[event.lang]);
    }
  }

  @override
  LangState fromJson(Map<String, dynamic> json) {
    if (json['locale'] == 'en') {
      return LangState(langData: appLangData[AppLang.EN]);
    }
    return LangState(langData: appLangData[AppLang.RU]);
  }

  @override
  Map<String, String> toJson(LangState state) {
    if (state.langData.languageCode == appLangData[AppLang.EN].languageCode) {
      return {'locale': 'en'};
    }
    return {'locale': 'ru'};
  }
}
