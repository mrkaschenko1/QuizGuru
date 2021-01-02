// 🎯 Dart imports:
import 'dart:async';
import 'dart:ui';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/app_localizations.dart';
import 'package:Quiz_Guru/state_management/blocs/lang/app_langs.dart';

part 'lang_event.dart';
part 'lang_state.dart';

class LangBloc extends HydratedBloc<LangEvent, LangState> {
  LangBloc() : super(LangState(langData: appLangData[AppLang.en]));

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
      return LangState(langData: appLangData[AppLang.en]);
    }
    return LangState(langData: appLangData[AppLang.ru]);
  }

  @override
  Map<String, String> toJson(LangState state) {
    if (state.langData.languageCode == appLangData[AppLang.en].languageCode) {
      return {'locale': 'en'};
    }
    return {'locale': 'ru'};
  }
}
