import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/blocs/lang/app_langs.dart';
import 'package:android_guru/blocs/lang/lang_bloc.dart';
import 'package:android_guru/blocs/theme/app_themes.dart';
import 'package:android_guru/blocs/theme/theme_bloc.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:android_guru/ui/widgets/settings_app_bar.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../injection_container.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _langValue;
  var _themeValue;
  final userRepository = sl.get<UserRepository>();

  @override
  void initState() {
    _themeValue = appThemeData.entries
        .firstWhere((element) =>
            element.key == BlocProvider.of<ThemeBloc>(context).state.themeName)
        .key
        .index;
    _langValue = appLangData.entries
        .firstWhere((element) =>
            element.value == BlocProvider.of<LangBloc>(context).state.langData)
        .key
        .index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SettingsAppBar(),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'General',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF656565)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border: Border.all(width: 2, color: Colors.black),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black, offset: Offset(0, 2))
                      ]),
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: ListTile(
                            dense: true,
                            leading: Icon(
                              FeatherIcons.globe,
                              color: Colors.black,
                              size: 30,
                            ),
                            title: Text(
                              StringUtils.capitalize(
                                  AppLocalizations.of(context)
                                      .translate('language')
                                      .toString()),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: DropdownButton(
                              value: _langValue,
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text(
                                    'English',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text(
                                    'Русский',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _langValue = value;
                                  if (_langValue == AppLang.EN.index) {
                                    BlocProvider.of<LangBloc>(context)
                                        .add(LangChanged(lang: AppLang.EN));
                                  } else {
                                    BlocProvider.of<LangBloc>(context)
                                        .add(LangChanged(lang: AppLang.RU));
                                  }
                                });
                              },
                            ),
                          )),
                      Container(
                        width: double.infinity,
                        child: ListTile(
                          dense: true,
                          leading: _themeValue == 0
                              ? Icon(FeatherIcons.sun,
                                  size: 30, color: Colors.black)
                              : Icon(FeatherIcons.moon,
                                  size: 30, color: Colors.black),
                          title: Text(
                            StringUtils.capitalize(AppLocalizations.of(context)
                                .translate('theme')
                                .toString()),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Switch(
                            value: _themeValue == 1 ? true : false,
                            onChanged: (value) {
                              setState(() {
                                _themeValue = value == true ? 1 : 0;
                                BlocProvider.of<ThemeBloc>(context).add(
                                  ThemeChanged(
                                      theme: AppTheme
                                          .values[value == true ? 1 : 0]),
                                );
                              });
                            },
                            activeColor: Colors.black,
                            activeTrackColor: Color(0xFFFE9D81),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                          ),
                          // trailing: DropdownButton(
                          //   value: _themeValue,
                          //   items: [
                          //     ...appThemeData
                          //         .map((key, value) => MapEntry(
                          //             key,
                          //             DropdownMenuItem(
                          //               child: Container(
                          //                   width: 60,
                          //                   child: Row(
                          //                     children: <Widget>[
                          //                       Container(
                          //                           color: value.primaryColor,
                          //                           child: SizedBox(
                          //                             width: 20,
                          //                             height: 20,
                          //                           )),
                          //                       Container(
                          //                           color: value.accentColor,
                          //                           child: SizedBox(
                          //                             width: 20,
                          //                             height: 20,
                          //                           )),
                          //                       Container(
                          //                           color: value
                          //                               .scaffoldBackgroundColor,
                          //                           child: SizedBox(
                          //                             width: 20,
                          //                             height: 20,
                          //                           )),
                          //                     ],
                          //                   )),
                          //               value: key.index,
                          //             )))
                          //         .values
                          //         .toList()
                          //   ],
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _themeValue = value;
                          //       BlocProvider.of<ThemeBloc>(context).add(
                          //           ThemeChanged(
                          //               theme: AppTheme.values[value]));
                          //     });
                          //   },
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Account',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF656565)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: FlatButton(
                      padding: const EdgeInsets.all(20),
                      color: Color(0xFFFE9D81),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      onPressed: () async {
                        var result = await userRepository.logout();
                        result.fold(
                          (l) => _showSnackBarError(context, l.message),
                          (r) => Navigator.of(context).pop(),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('logout')
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      )),
                )
              ]),
        ));
  }

  void _showSnackBarError(BuildContext ctx, String message) {
    Scaffold.of(ctx).removeCurrentSnackBar();
    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
