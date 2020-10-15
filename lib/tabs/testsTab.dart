import 'package:android_guru/cubits/test/test_cubit.dart';
import 'package:android_guru/screens/question_screen.dart';
import 'package:android_guru/widgets/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection_container.dart';

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
                    return tab_refresh_icon(refreshTab: () => refreshTab(context),);
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

class tab_refresh_icon extends StatelessWidget {
  final Function refreshTab;

  const tab_refresh_icon({
    Key key, this.refreshTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: IconButton(
          iconSize: 100,
          icon: Icon(Icons.refresh),
          onPressed: refreshTab,
          color: Theme.of(context).backgroundColor,
        )
    );
  }
}
