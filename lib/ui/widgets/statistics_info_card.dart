import 'package:flutter/material.dart';

class StatisticsInfoCard extends StatelessWidget {
  final title;
  final value;

  StatisticsInfoCard({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: 65,
      width: mediaQuery.size.width / 2 * 0.65,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: theme.cardColor,
        border: Border.all(color: theme.accentColor, width: 2),
        boxShadow: [
          BoxShadow(color: theme.accentColor, offset: Offset(0, 2)),
        ],
      ),
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
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: theme.accentColor),
            ),
          ),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: theme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
