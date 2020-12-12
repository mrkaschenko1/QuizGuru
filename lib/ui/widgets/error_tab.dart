// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// Project imports:
import '../../app_localizations.dart';

class ErrorTab extends StatelessWidget {
  final Function refreshTab;

  const ErrorTab({
    Key key,
    this.refreshTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.asset('assets/images/doodles/error_person.png')),
        Container(
            margin: EdgeInsets.only(right: 20, left: 20, bottom: 50),
            width: double.infinity,
            child: FlatButton(
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                    AppLocalizations.of(context)
                        .translate('try_again')
                        .toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor)),
                Icon(
                  FeatherIcons.refreshCw,
                  size: 26,
                  color: Theme.of(context).primaryColor,
                )
              ]),
              onPressed: refreshTab,
              color: Theme.of(context).accentColor,
            )),
      ],
    );
  }
}
