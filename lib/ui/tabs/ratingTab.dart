import 'package:android_guru/cubits/rating/rating_cubit.dart';
import 'package:android_guru/ui/widgets/podium.dart';
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
    final bool isEmpty = rating.sublist(3).isEmpty;
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
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.black, offset: Offset(0, 2))
                                // ],
                              ),
                            ),
                            title: Text(
                              elem['username'],
                              style: const TextStyle(
                                  color: Colors.black,
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
                                    color: Color(0xFFFE9D81),
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 1))
                                    ]),
                                child: Center(
                                  child: Text(
                                    elem['points'].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          margin: const EdgeInsets.only(bottom: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black, offset: Offset(0, 2))
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
