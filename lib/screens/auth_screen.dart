import 'dart:math';

import 'package:android_guru/blocs/login/login_bloc.dart';
import 'package:android_guru/network/network_info.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:android_guru/widgets/animated_wave.dart';
import 'package:android_guru/widgets/auth_form.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
          children: [
            onTop(Transform.rotate(
              angle: pi,
              child: AnimatedWave(
                height: 160,
                speed: 0.8,
                offset: pi / 8,
              ),
            )),
            onBottom(AnimatedWave(
              height: 160,
              speed: 0.8,
              offset: pi / 2,
            ),),
            Positioned.fill(
                child: BlocProvider<LoginBloc>(
                    create: (context) => LoginBloc(
                        userRepository: UserRepository(
                          firebaseAuth: FirebaseAuth.instance,
                          googleSignIn: GoogleSignIn(),
                          firebaseDatabase: FirebaseDatabase.instance,
                          networkInfo: NetworkInfoImpl(DataConnectionChecker())
                        )
                    ),
                    child: AuthForm()
                )
            ),
          ])
    );
  }

  onBottom(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );

  onTop(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.topCenter,
      child: child,
    ),
  );
}
