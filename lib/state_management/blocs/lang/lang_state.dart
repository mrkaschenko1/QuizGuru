part of 'lang_bloc.dart';

class LangState extends Equatable {
  final Locale langData;
  LangState({@required this.langData});

  @override
  List<Object> get props => [this.langData];
}
