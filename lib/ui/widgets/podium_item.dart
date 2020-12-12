// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../app_localizations.dart';

class PodiumItem extends StatelessWidget {
  final height;
  final place;
  final points;
  final userName;

  const PodiumItem(
      {Key key, this.height, this.place, this.points, this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String pointsString = points == null
        ? ''
        : '$points ${AppLocalizations.of(context).translate('points')}';
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            userName ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.accentColor,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            pointsString,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: theme.accentColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: height,
            margin: EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                color: theme.accentColor),
            child: Center(
              child: Text(
                place.toString(),
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
