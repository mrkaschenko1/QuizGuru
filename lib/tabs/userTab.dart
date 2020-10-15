import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/cubits/user/user_cubit.dart';
import 'package:android_guru/widgets/statistics_info_card.dart';
import 'package:android_guru/widgets/tab_refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection_container.dart';

class UserTab extends StatelessWidget {

  void refreshTab(BuildContext context) async {
    await BlocProvider.of<UserCubit>(context).fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl.get<UserCubit>()..fetchUser(),
      child: BlocConsumer<UserCubit, UserState>(
        builder: (context, state) {
          if (state.status == UserStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (state.user != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        color: Theme.of(context).cardColor.withOpacity(0.5),
                        boxShadow: [const BoxShadow(color: Colors.grey)]
                    ),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate('profile_info').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                            ),
                            margin: const EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 15),
                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
                            child: Text(
                                '${AppLocalizations.of(context).translate('login').toString()}: ${state.user.username}',
                                style: const TextStyle(fontSize: 18, color: Colors.black87)
                            )
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                            ),
                            margin: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
                            child: Text(
                                '${AppLocalizations.of(context).translate('email').toString()}: ${state.user.email}',
                                style: const TextStyle(fontSize: 18, color: Colors.black87)
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      color: Theme.of(context).cardColor.withOpacity(0.5),
                      boxShadow: [const BoxShadow(color: Colors.grey)],
                    ),
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate('statistics').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(children: <Widget>[
                            StatisticsInfoCard(title: AppLocalizations.of(context).translate('points').toString(), value: state.user.points,),
                            StatisticsInfoCard(title: AppLocalizations.of(context).translate('tests_passed').toString(), value: state.user.testsPassedCount,),
                            StatisticsInfoCard(title: AppLocalizations.of(context).translate('position').toString(), value: state.user.ratingPosition,),
                          ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return TabRefreshButton(refreshTab: () => refreshTab(context),);
            }
          }
        },
        listener: (context, state) {
          if (state.status == UserStatus.failure) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
                SnackBar(backgroundColor: Colors.red, content: Text(state.message),)
            );
          }
        },
      ),
    );
  }
}