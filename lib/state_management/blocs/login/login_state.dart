part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {
  final bool isLogin;

  const LoginLoading({this.isLogin});

  @override
  List<Object> get props => [isLogin];
}

class LoginFormState extends LoginState {}

class SignUpFormState extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  final bool isLogin;

  const LoginFailure({@required this.error, @required this.isLogin});

  @override
  List<Object> get props => [error, isLogin];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
