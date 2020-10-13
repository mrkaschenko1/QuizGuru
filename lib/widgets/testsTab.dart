import 'package:android_guru/cubits/test/test_cubit.dart';
import 'package:android_guru/network/network_info.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:android_guru/screens/question_screen.dart';
import 'package:android_guru/widgets/test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TestsTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
        TestCubit(repository: TestRepository(
          userRepository: UserRepository(
            firebaseAuth: FirebaseAuth.instance,
            firebaseDatabase: FirebaseDatabase.instance,
            googleSignIn: GoogleSignIn(),
            networkInfo: NetworkInfoImpl(DataConnectionChecker())
          ),
          firebaseDatabase: FirebaseDatabase.instance,
          networkInfo: NetworkInfoImpl(DataConnectionChecker())
        ))
          ..fetchTests(),
        child: BlocConsumer<TestCubit, TestState>(
            builder: (context, state) {
              if (state.status == TestStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
              } else {
                  if (state.tests.isNotEmpty) {
                    return ListView(
                      children: <Widget>[
                        ...state.tests.map((test) {
                          return Test(
                            key: ValueKey(test.id),
                            test: test,
                          );
                        }
                        ).toList()
                      ],
                    );
                  } else {
                    return Center(
                        child: IconButton(
                          iconSize: 100,
                          icon: Icon(Icons.refresh),
                          onPressed: () async {
                            await BlocProvider.of<TestCubit>(context).fetchTests();
                          },
                          color: Theme.of(context).backgroundColor,
                        )
                    );
                  }
              }
            },
            listener: (context, state) {
              if (state.status == TestStatus.failure) {
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                    SnackBar(backgroundColor: Colors.red, content: Text(state.message),)
                );
              } else if (state.status == TestStatus.started) {
                Navigator.of(context)
                .pushReplacementNamed(QuestionScreen.routeName, arguments: state.test);
              }
            },
        )
    );
  }
}
