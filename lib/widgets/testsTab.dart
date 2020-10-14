import 'package:android_guru/cubits/test/test_cubit.dart';
import 'package:android_guru/screens/question_screen.dart';
import 'package:android_guru/widgets/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection_container.dart';

class TestsTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
        sl.get<TestCubit>()
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
