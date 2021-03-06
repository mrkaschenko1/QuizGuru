// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:charcode/html_entity.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/app_localizations.dart';
import 'package:Quiz_Guru/models/test_model.dart';
import 'package:Quiz_Guru/state_management/cubits/test/test_cubit.dart';

class TestCard extends StatelessWidget {
  final TestModel test;

  TestCard({Key key, this.test}) : super(key: key);

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    final _mediaQueary = MediaQuery.of(context);
    final _size = _mediaQueary.size.width / 2 * 0.88;
    const _iconSize = 55.0;
    const _iconContainerSize = _iconSize + 3;
    final theme = Theme.of(context);
    final String _attempts =
        '${AppLocalizations.of(context).translate('user_tries')}: ${'${test.userTries}/${test.tries ?? String.fromCharCode($infin)}'}';
    final String _bestScore =
        '${AppLocalizations.of(context).translate('best_score')}: ${test.userBestScore}';
    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: Container(
        height: _size,
        width: _size,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: theme.accentColor,
            width: 2,
          ),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.accentColor,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              test.title,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.accentColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${test.questions.length} ${AppLocalizations.of(context).translate("questions")}',
              style: TextStyle(fontSize: 20, color: theme.accentColor),
            ),
            const Spacer(),
            if (test.isStarting)
              LinearProgressIndicator(
                backgroundColor: theme.backgroundColor,
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: _iconContainerSize,
                    width: _iconContainerSize,
                    child: GestureDetector(
                      onTap: () => cardKey.currentState.toggleCard(),
                      child: Stack(
                        children: <Widget>[
                          const Positioned(
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
                            color: theme.unselectedWidgetColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: _iconContainerSize,
                    width: _iconContainerSize,
                    child: GestureDetector(
                      onTap: (test.isStarting ||
                              (test.userTries ?? 0) >=
                                  (test.tries ?? double.infinity))
                          ? () {
                              Scaffold.of(context).hideCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  backgroundColor: theme.errorColor,
                                  content: Text(AppLocalizations.of(context)
                                      .translate('no_more_attempts'))));
                            }
                          : () => BlocProvider.of<TestCubit>(context)
                              .startTest(test.id),
                      child: Stack(
                        children: <Widget>[
                          const Positioned(
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
                            color: theme.accentColor,
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
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: theme.accentColor,
            width: 2,
          ),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.accentColor,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              test.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.accentColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _attempts,
              style: TextStyle(fontSize: 18, color: theme.accentColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _bestScore,
              style: TextStyle(fontSize: 18, color: theme.accentColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
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
                        const Positioned(
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
                          color: theme.accentColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
