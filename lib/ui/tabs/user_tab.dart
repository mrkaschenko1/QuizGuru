import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/cubits/user/user_cubit.dart';
import 'package:android_guru/ui/widgets/statistics_info_card.dart';
import 'package:android_guru/ui/widgets/error_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../injection_container.dart';

class UserTab extends StatelessWidget {
  void refreshTab(BuildContext context) async {
    await BlocProvider.of<UserCubit>(context).fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => sl.get<UserCubit>()..fetchUser(),
      child: BlocConsumer<UserCubit, UserState>(
        builder: (context, state) {
          if (state.status == UserStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (state.user != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/doodles/avatar.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    state.user.username,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        color: theme.accentColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    state.user.email,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: theme.accentColor),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  StatisticsInfoCard(
                                    title: AppLocalizations.of(context)
                                        .translate('points')
                                        .toString(),
                                    value: state.user.points,
                                  ),
                                  StatisticsInfoCard(
                                    title: AppLocalizations.of(context)
                                        .translate('tests_passed')
                                        .toString(),
                                    value: state.user.testsPassedCount,
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              StatisticsInfoCard(
                                title: AppLocalizations.of(context)
                                    .translate('position')
                                    .toString(),
                                value: state.user.ratingPosition,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return ErrorTab(
                refreshTab: () => refreshTab(context),
              );
            }
          }
        },
        listener: (context, state) {
          if (state.status == UserStatus.failure) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.message),
            ));
          }
        },
      ),
    );
  }
}
