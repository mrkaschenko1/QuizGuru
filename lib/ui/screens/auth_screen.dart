// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../injection_container.dart';
import '../../state_management/blocs/login/login_bloc.dart';
import '../../ui/widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(children: [
          Positioned(
            top: 75,
            left: -25,
            child: Image.asset(
              'assets/images/doodles/greeting_person.png',
              scale: 0.9,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) => Container(
                margin: EdgeInsets.only(top: 230),
                child: BlocProvider<LoginBloc>(
                    create: (context) => sl.get<LoginBloc>(),
                    child: AuthForm())),
          ),
        ]),
      ),
    );
  }
}
