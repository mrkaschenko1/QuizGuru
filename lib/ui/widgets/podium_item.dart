import 'package:android_guru/app_localizations.dart';
import 'package:flutter/material.dart';

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
              color: Colors.black,
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
              color: Colors.black,
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
                color: Colors.black),
            child: Center(
              child: Text(
                place.toString(),
                style: TextStyle(
                    color: Colors.white,
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
