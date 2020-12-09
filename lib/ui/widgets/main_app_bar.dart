import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/injection_container.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:android_guru/ui/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MainAppBar extends StatelessWidget {
  final userRepository = sl.get<UserRepository>();
  final String userName;

  MainAppBar({Key key, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 10, bottom: 5),
      width: double.infinity,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('hello').toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  userName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  FeatherIcons.settings,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => SettingsScreen(),
                    maintainState: true,
                  ));
                },
              ),
              // Builder(
              //   builder: (ctx) => IconButton(
              //     icon: Icon(
              //       Icons.exit_to_app,
              //       color: Colors.black,
              //     ),
              //     onPressed: () async {
              //       var result = await userRepository.logout();
              //       result.fold(
              //         (l) => _showSnackBarError(ctx, l.message),
              //         (r) => print("logged out"),
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }

  // void _showSnackBarError(BuildContext ctx, String message) {
  //   Scaffold.of(ctx).removeCurrentSnackBar();
  //   Scaffold.of(ctx).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  // }
}
