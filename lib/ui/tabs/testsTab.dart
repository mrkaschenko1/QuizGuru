import 'package:android_guru/cubits/test/test_cubit.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:android_guru/ui/screens/question_screen.dart';
import 'file:///C:/Users/AndreyKas/AndroidStudioProjects/android_guru/lib/ui/widgets/tab_refresh_button.dart';
import 'file:///C:/Users/AndreyKas/AndroidStudioProjects/android_guru/lib/ui/widgets/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart';

class TestsTab extends StatelessWidget {

  void refreshTab(BuildContext context) async {
    await BlocProvider.of<TestCubit>(context).fetchTests();
  }

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
                    return TabRefreshButton(refreshTab: () => refreshTab(context),);
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
                .pushReplacement(MaterialPageRoute(
                  builder: (context) => QuestionScreen(test: state.test)
                ));
              }
            },
        )
    );
  }
}