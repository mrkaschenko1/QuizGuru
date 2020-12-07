import 'package:android_guru/blocs/login/login_bloc.dart';
import 'package:android_guru/ui/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(children: [
          Positioned(
            top: 85,
            left: -25,
            child: Image.asset(
              'assets/images/greeting_person.png',
              scale: 0.9,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) => Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(top: 240),
                child: BlocProvider<LoginBloc>(
                    create: (context) => sl.get<LoginBloc>(),
                    child: AuthForm())),
          ),
        ]),
      ),
    );
  }
}
