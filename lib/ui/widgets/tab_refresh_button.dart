import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabRefreshButton extends StatelessWidget {
  final Function refreshTab;

  const TabRefreshButton({
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
                Text('Try again ',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                Icon(
                  FeatherIcons.refreshCw,
                  size: 26,
                )
              ]),
              onPressed: refreshTab,
              color: Colors.black,
            )),
      ],
    );
  }
}
