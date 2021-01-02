part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final AppTheme themeName;
  final ThemeData themeData;
  const ThemeState({@required this.themeName, @required this.themeData});

  @override
  List<Object> get props => [themeName, themeData];
}
