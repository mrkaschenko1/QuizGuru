part of 'lang_bloc.dart';

class LangState extends Equatable {
  final Locale langData;
  const LangState({@required this.langData});

  @override
  List<Object> get props => [langData];
}
