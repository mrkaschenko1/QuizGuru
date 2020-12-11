import 'package:android_guru/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(top: 30),
      height: 80,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(color: Colors.black, offset: Offset(0, 2))
              ]),
              height: 48,
              width: 48,
              child: SvgPicture.asset(
                'assets/images/icons/back_circle_icon.svg',
                alignment: Alignment.center,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            AppLocalizations.of(context).translate('settings').toString(),
            style: TextStyle(
                color: theme.accentColor,
                fontWeight: FontWeight.w900,
                fontSize: 30),
          ),
          SizedBox(
            height: 48,
            width: 48,
          ),
        ],
      ),
    );
  }
}
