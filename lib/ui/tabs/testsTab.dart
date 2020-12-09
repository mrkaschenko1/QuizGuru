import 'package:android_guru/cubits/test/test_cubit.dart';
import 'package:android_guru/ui/screens/question_screen.dart';
import 'package:android_guru/ui/widgets/test_card.dart';
import 'package:android_guru/ui/widgets/main_app_bar.dart';
import 'package:android_guru/ui/widgets/tab_refresh_button.dart';
import 'package:android_guru/ui/widgets/user_statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_localizations.dart';
import '../../injection_container.dart';

class TestsTab extends StatelessWidget {
  void refreshTab(BuildContext context) async {
    await BlocProvider.of<TestCubit>(context).fetchTests();
  }

  @override
  Widget build(BuildContext context) {
    final _gaugeSize = MediaQuery.of(context).size.width / 3 * 0.90;
    return BlocProvider(
        create: (_) => sl.get<TestCubit>()..fetchTests(),
        child: BlocConsumer<TestCubit, TestState>(
          builder: (context, state) {
            if (state.status == TestStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (state.tests.isNotEmpty) {
                return Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              height: _gaugeSize,
                              width: _gaugeSize,
                              child: UserStatistics(
                                total: state.tests
                                    .map((test) => test.questions.length)
                                    .toList()
                                    .fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue + element),
                                current: state.user.points,
                                annotation: 'points',
                                isPercent: false,
                              ),
                            ),
                            Container(
                              height: _gaugeSize,
                              width: _gaugeSize,
                              child: UserStatistics(
                                total: state.tests.length,
                                current: state.user.testsPassedCount,
                                annotation: 'tests',
                                isPercent: false,
                              ),
                            ),
                            Container(
                              height: _gaugeSize,
                              width: _gaugeSize,
                              child: UserStatistics(
                                total: 100,
                                current: 26,
                                annotation: 'accuracy',
                                isPercent: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('quizzes_tab')
                              .toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: GridView.count(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            crossAxisCount: 1,
                            children: <Widget>[
                              ...state.tests.map((test) {
                                return TestCard(
                                  test: test,
                                );
                              }).toList()
                            ],
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: ListView(
                      //     children: <Widget>[
                      //       ...state.tests.map((test) {
                      //         return Test(
                      //           key: ValueKey(test.id),
                      //           test: test,
                      //         );
                      //       }).toList()
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                );
              } else {
                return TabRefreshButton(
                  refreshTab: () => refreshTab(context),
                );
              }
            }
          },
          listener: (context, state) {
            if (state.status == TestStatus.failure) {
              Scaffold.of(context).removeCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message),
              ));
            } else if (state.status == TestStatus.started) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => QuestionScreen(test: state.test)));
            }
          },
        ));
  }
}
