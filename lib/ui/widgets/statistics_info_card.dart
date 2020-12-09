import 'package:flutter/material.dart';

class StatisticsInfoCard extends StatelessWidget {
  final title;
  final value;

  StatisticsInfoCard({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value.toString(),
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.caption,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
