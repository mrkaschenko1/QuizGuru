// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../app_localizations.dart';
import '../../injection_container.dart';
import '../../state_management/cubits/test/test_cubit.dart';
import '../../ui/screens/question_screen.dart';
import '../../ui/widgets/error_tab.dart';
import '../../ui/widgets/test_card.dart';
import '../../ui/widgets/user_statistics.dart';

class TestsTab extends StatelessWidget {
  void refreshTab(BuildContext context) async {
    await BlocProvider.of<TestCubit>(context).fetchTests();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                                current: state.user?.points ?? 0,
                                annotation: AppLocalizations.of(context)
                                    .translate('points'),
                                isPercent: false,
                              ),
                            ),
                            Container(
                              height: _gaugeSize,
                              width: _gaugeSize,
                              child: UserStatistics(
                                total: state.tests.length,
                                current: state.user?.testsPassedCount ?? 0,
                                annotation: AppLocalizations.of(context)
                                    .translate('quizzes'),
                                isPercent: false,
                              ),
                            ),
                            Container(
                              height: _gaugeSize,
                              width: _gaugeSize,
                              child: UserStatistics(
                                total: 100,
                                current: 26,
                                annotation: AppLocalizations.of(context)
                                    .translate('accuracy'),
                                isPercent: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          StringUtils.capitalize(AppLocalizations.of(context)
                              .translate('quizzes_tab')
                              .toString()),
                          style: TextStyle(
                              color: theme.accentColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: ListView.builder(
                            itemCount: state.tests.length,
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 20, right: 10),
                            itemBuilder: (context, index) => Container(
                                width: 200,
                                padding: EdgeInsets.only(right: 10),
                                child: TestCard(test: state.tests[index])),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ErrorTab(
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
