part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'LoginButtonPressed { email: $email, password: $password }';
}

class SignUpButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final String email;

  const SignUpButtonPressed({
    @required this.username,
    @required this.password,
    @required this.email
  });

  @override
  List<Object> get props => [username, password, email];

  @override
  String toString() =>
      'SignUpButtonPressed { email: $email, password: $password, username: $username }';
}

class GoogleSignUpButtonPressed extends LoginEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'GoogleSignUpButtonPressed';
}
