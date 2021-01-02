// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/injection_container.dart';
import 'package:Quiz_Guru/state_management/blocs/login/login_bloc.dart';
import 'package:Quiz_Guru/ui/widgets/auth/auth_form.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Positioned(
            top: 75,
            left: -25,
            child: Image.asset(
              'assets/images/doodles/greeting_person.png',
              scale: 0.9,
            ),
          ),
          LayoutBuilder(
            builder: (_, __) => Container(
                margin: const EdgeInsets.only(top: 230),
                child: BlocProvider<LoginBloc>(
                    create: (_) => sl.get<LoginBloc>(),
                    child: const AuthForm())),
          ),
        ]),
      ),
    );
  }
}
