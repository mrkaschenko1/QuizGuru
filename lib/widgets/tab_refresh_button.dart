import 'package:flutter/material.dart';

class TabRefreshButton extends StatelessWidget {
  final Function refreshTab;

  const TabRefreshButton({
    Key key, this.refreshTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: IconButton(
          iconSize: 100,
          icon: Icon(Icons.refresh),
          onPressed: refreshTab,
          color: Theme.of(context).backgroundColor,
        )
    );
  }
}
