// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/app_localizations.dart';
import 'package:Quiz_Guru/injection_container.dart';
import 'package:Quiz_Guru/repositories/user_repository.dart';
import 'package:Quiz_Guru/ui/screens/settings_screen.dart';

class MainAppBar extends StatelessWidget {
  final userRepository = sl.get<UserRepository>();
  final bool isUserTab;

  MainAppBar({Key key, this.isUserTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 10, bottom: 5),
      width: double.infinity,
      color: theme.scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isUserTab)
                Text(
                  AppLocalizations.of(context).translate('hello').toString(),
                  style: TextStyle(
                      color: theme.accentColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
              if (!isUserTab)
                Text(
                  AppLocalizations.of(context)
                      .translate('app_bar_subtitle')
                      .toString(),
                  style: TextStyle(
                      color: theme.accentColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                )
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  FeatherIcons.settings,
                  color: theme.accentColor,
                  size: 30,
                ),
                onPressed: () async {
                  Navigator.of(context)
                      .push<dynamic>(MaterialPageRoute<dynamic>(
                    builder: (ctx) => SettingsScreen(),
                  ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
