part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent([List props = const []]);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final UserCredential userCredential;

  LoggedIn({@required this.userCredential}) : super([userCredential]);

  @override
  String toString() => 'LoggedIn { userCredentials: $userCredential }';

  @override
  List<Object> get props => [userCredential];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}
