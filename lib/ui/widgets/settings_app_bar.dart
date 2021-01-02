// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/app_localizations.dart';

class SettingsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 30),
      height: 80,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              height: 48,
              width: 48,
              child: SvgPicture.asset(
                'assets/images/icons/back_circle_icon.svg',
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context).translate('settings').toString(),
            style: TextStyle(
                color: theme.accentColor,
                fontWeight: FontWeight.w900,
                fontSize: 30),
          ),
          const SizedBox(
            height: 48,
            width: 48,
          ),
        ],
      ),
    );
  }
}
