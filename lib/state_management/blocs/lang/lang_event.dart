part of 'lang_bloc.dart';

abstract class LangEvent extends Equatable {
  const LangEvent();
}

class LangChanged extends LangEvent {
  final AppLang lang;

  const LangChanged({@required this.lang});

  @override
  List<Object> get props => [lang];
}
