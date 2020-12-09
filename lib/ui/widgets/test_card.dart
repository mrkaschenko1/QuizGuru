import 'package:android_guru/cubits/test/test_cubit.dart';
import 'package:android_guru/models/test_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:charcode/html_entity.dart';

import '../../app_localizations.dart';

class TestCard extends StatelessWidget {
  final TestModel test;

  TestCard({Key key, this.test}) : super(key: key);

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    final _mediaQueary = MediaQuery.of(context);
    final _size = _mediaQueary.size.width / 2 * 0.88;
    final _iconSize = 55.0;
    final _iconContainerSize = _iconSize + 3;
    final String _attempts =
        AppLocalizations.of(context).translate('user_tries').toString() +
            ': ' +
            '${test.userTries}/${test.tries ?? String.fromCharCode($infin)}';
    final String _bestScore =
        AppLocalizations.of(context).translate('best_score').toString() +
            ': ' +
            test.userBestScore.toString();
    return FlipCard(
        key: cardKey,
        flipOnTouch: false,
        direction: FlipDirection.HORIZONTAL, // default
        front: Container(
          height: _size,
          width: _size,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black, offset: Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                test.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${test.questions.length} questions',
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              test.isStarting
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: _iconContainerSize,
                          width: _iconContainerSize,
                          child: GestureDetector(
                            onTap: () => cardKey.currentState.toggleCard(),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 3,
                                  child: Icon(
                                    FeatherIcons.info,
                                    size: _iconSize,
                                    color: Colors.black12,
                                  ),
                                ),
                                Icon(
                                  FeatherIcons.info,
                                  size: _iconSize,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: _iconContainerSize,
                          width: _iconContainerSize,
                          child: GestureDetector(
                            onTap: () {
                              BlocProvider.of<TestCubit>(context)
                                  .startTest(test.id);
                            },
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 3,
                                  child: Icon(
                                    FeatherIcons.playCircle,
                                    size: _iconSize,
                                    color: Colors.black12,
                                  ),
                                ),
                                Icon(
                                  FeatherIcons.playCircle,
                                  size: _iconSize,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
        back: Container(
          height: _size,
          width: _size,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black, offset: Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                test.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _attempts,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                _bestScore,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: _iconContainerSize,
                    width: _iconContainerSize,
                    child: GestureDetector(
                      onTap: () => cardKey.currentState.toggleCard(),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 3,
                            child: Icon(
                              FeatherIcons.arrowLeftCircle,
                              size: _iconSize,
                              color: Colors.black12,
                            ),
                          ),
                          Icon(
                            FeatherIcons.arrowLeftCircle,
                            size: _iconSize,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}