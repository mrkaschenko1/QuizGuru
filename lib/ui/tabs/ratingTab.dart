import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/cubits/rating/rating_cubit.dart';
import 'package:android_guru/ui/widgets/podium.dart';
import 'package:android_guru/ui/widgets/tab_refresh_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../injection_container.dart';

class RatingTab extends StatelessWidget {
  void refreshTab(BuildContext context) async {
    await BlocProvider.of<RatingCubit>(context).fetchRating();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl.get<RatingCubit>()..fetchRating(),
      child: BlocConsumer<RatingCubit, RatingState>(
        builder: (context, state) {
          if (state.status == RatingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (state.rating.isNotEmpty) {
              return Rating(rating: state.rating);
            } else {
              return TabRefreshButton(
                refreshTab: () => refreshTab(context),
              );
            }
          }
        },
        listener: (context, state) {
          if (state.status == RatingStatus.failure) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.message),
            ));
          } else if (state.status == RatingStatus.refreshed) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(state.message),
            ));
          }
        },
      ),
    );
  }
}

class Rating extends StatelessWidget {
  final rating;

  const Rating({
    this.rating,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = rating.sublist(2).isEmpty;
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 15),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Podium(
            topUsers: rating.take(3).toList(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.black,
            height: 1,
          ),
          SizedBox(
            height: 20,
          ),
          !isEmpty
              ? ListView(
                  children: <Widget>[
                    ...(rating.sublist(2).map((elem) {
                      return Container(
                        child: ListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(right: 10, left: 5),
                          leading: CircleAvatar(
                            minRadius: 5,
                            maxRadius: 20,
                            child: Text(
                              (rating.indexOf(elem) + 1).toString(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          title: Text(
                            elem['username'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                letterSpacing: 0.5),
                          ),
                          trailing: Text(
                            '${elem['points'].toString()} ${AppLocalizations.of(context).translate('pts')}',
                            style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: 20),
                          ),
                        ),
                        margin: const EdgeInsets.only(top: 5, bottom: 2),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.6),
                            boxShadow: [const BoxShadow(color: Colors.grey)]),
                      );
                    }))
                  ],
                )
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Hey! We need more players!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/images/doodles/curious_person.png',
                          height: 300,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}
