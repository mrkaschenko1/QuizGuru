// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🌎 Project imports:
import '../../../repositories/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  LoginBloc({
    @required this.userRepository,
  }) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is ShowLoginForm) {
      yield LoginFormState();
    } else if (event is ShowSignUpForm) {
      yield SignUpFormState();
    } else if (event is LoginButtonPressed) {
      yield LoginLoading(isLogin: true);

      try {
        final userCredential = await userRepository.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        userCredential
            .fold((l) => {throw FirebaseAuthException(message: l.message)},
                (r) async* {
          yield LoginInitial();
        });
      } catch (error) {
        yield LoginFailure(error: error.toString(), isLogin: true);
        yield LoginFormState();
      }
    } else if (event is SignUpButtonPressed) {
      yield LoginLoading(isLogin: false);

      try {
        final userCredential = await userRepository.signUp(
          username: event.username,
          email: event.email,
          password: event.password,
        );

        userCredential
            .fold((l) => {throw FirebaseAuthException(message: l.message)},
                (r) async* {
          yield LoginInitial();
        });
      } catch (error) {
        yield LoginFailure(error: error.toString(), isLogin: false);
        yield SignUpFormState();
      }
    } else if (event is GoogleSignUpButtonPressed) {
      yield LoginLoading(isLogin: event.isLogin);
      try {
        final userCredential = await userRepository.signInWithGoogle();

        userCredential
            .fold((l) => {throw FirebaseAuthException(message: l.message)},
                (r) async* {
          yield LoginInitial();
        });
      } catch (error) {
        yield LoginFailure(error: error.toString(), isLogin: event.isLogin);
        if (event.isLogin) {
          yield LoginInitial();
        } else {
          yield SignUpFormState();
        }
      }
    }
  }
}
