// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../app_localizations.dart';
import '../../injection_container.dart';
import '../../state_management/cubits/rating/rating_cubit.dart';
import '../../ui/widgets/error_tab.dart';
import '../../ui/widgets/podium.dart';

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
              return ErrorTab(
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
    print(rating);
    final theme = Theme.of(context);
    bool isEmpty;
    try {
      isEmpty = rating[3] != null;
    } catch (e) {
      isEmpty = true;
    }
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, top: 15),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Podium(
            topUsers: rating.length >= 3
                ? rating.take(3).toList()
                : rating.take(rating.length).toList(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: theme.accentColor,
            height: 1,
          ),
          !isEmpty
              ? Expanded(
                  child: ListView(
                    children: <Widget>[
                      ...(rating.sublist(3).map((elem) {
                        return Container(
                          child: ListTile(
                            dense: true,
                            contentPadding:
                                const EdgeInsets.only(right: 0, left: 0),
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: Center(
                                child: Text(
                                  (rating.indexOf(elem) + 1).toString(),
                                  style: TextStyle(
                                      color: theme.accentColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                border: Border.all(
                                  width: 2,
                                  color: theme.accentColor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            title: Text(
                              elem['username'],
                              style: TextStyle(
                                  color: theme.accentColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  letterSpacing: 0.5),
                            ),
                            trailing: SizedBox(
                              height: 45,
                              width: 45,
                              child: Container(
                                margin: EdgeInsets.only(right: 2),
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    border: Border.all(
                                        width: 2, color: theme.accentColor),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                          color: theme.accentColor,
                                          offset: Offset(0, 1))
                                    ]),
                                child: Center(
                                  child: Text(
                                    elem['points'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          margin: const EdgeInsets.only(bottom: 2),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.accentColor, width: 2),
                            borderRadius: BorderRadius.circular(16),
                            color: theme.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: theme.accentColor,
                                  offset: Offset(0, 2))
                            ],
                          ),
                        );
                      }))
                    ],
                  ),
                )
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('more_players_needed')
                            .toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: theme.accentColor),
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
