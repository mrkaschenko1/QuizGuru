import 'dart:async';

import 'package:android_guru/blocs/auth/authentication_bloc.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  }) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {

        final userCredential = await userRepository.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        userCredential.fold(
          (l) => {
              throw FirebaseAuthException(message: l.message)
            },
          (r) async* {
              authenticationBloc.add(LoggedIn(userCredential: r));
              yield LoginInitial();
      });
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    } else if (event is SignUpButtonPressed) {
      yield LoginLoading();

      try {

        final userCredential = await userRepository.signUp(
          username: event.username,
          email: event.email,
          password: event.password,
        );

        userCredential.fold(
                (l) => {
              throw FirebaseAuthException(message: l.message)
            },
                (r) async* {
              authenticationBloc.add(LoggedIn(userCredential: r));
              yield LoginInitial();
            });
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    } else if (event is GoogleSignUpButtonPressed) {
      yield LoginLoading();
      try {
        final userCredential = await userRepository.signInWithGoogle();

        userCredential.fold(
          (l) => {
            throw FirebaseAuthException(message: l.message)
          },
          (r) async* {
            authenticationBloc.add(LoggedIn(userCredential: r));
            yield LoginInitial();
          });
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
