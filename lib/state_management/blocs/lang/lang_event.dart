part of 'lang_bloc.dart';

abstract class LangEvent extends Equatable {
  LangEvent([List props = const []]);
}

class LangChanged extends LangEvent {
  final AppLang lang;

  LangChanged({@required this.lang});

  @override
  List<Object> get props => [this.lang];
}
