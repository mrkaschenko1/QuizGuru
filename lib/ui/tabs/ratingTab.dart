import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/cubits/rating/rating_cubit.dart';
import 'package:android_guru/ui/widgets/tab_refresh_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              onRefresh: BlocProvider.of<RatingCubit>(context).refreshRating,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    color: Theme.of(context).cardColor.withOpacity(0.3)),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 0, top: 10),
                child: Column(children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).colorScheme.secondary),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            Icons.school,
                            size: 60,
                            color: Theme.of(context).colorScheme.background,
                          ),
                          Text(
                            "${AppLocalizations.of(context).translate('top').toUpperCase()} 10",
                            style: TextStyle(
                                fontSize: 35,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                          Icon(
                            Icons.school,
                            size: 60,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ]),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        ...(rating.map((elem) {
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
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.6),
                                boxShadow: [
                                  const BoxShadow(color: Colors.grey)
                                ]),
                          );
                        }))
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
