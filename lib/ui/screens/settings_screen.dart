// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// 🌎 Project imports:
import '../../app_localizations.dart';
import '../../injection_container.dart';
import '../../repositories/user_repository.dart';
import '../../state_management/blocs/lang/app_langs.dart';
import '../../state_management/blocs/lang/lang_bloc.dart';
import '../../state_management/blocs/theme/app_themes.dart';
import '../../state_management/blocs/theme/theme_bloc.dart';
import '../../ui/widgets/settings_app_bar.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
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
                    AppLocalizations.of(context)
                        .translate('general')
                        .toString(),
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
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                            color: theme.accentColor, offset: Offset(0, 2))
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
                              color: theme.accentColor,
                              size: 30,
                            ),
                            title: Text(
                              StringUtils.capitalize(
                                  AppLocalizations.of(context)
                                      .translate('language')
                                      .toString()),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.accentColor),
                            ),
                            trailing: DropdownButton(
                              dropdownColor: theme.primaryColor,
                              value: _langValue,
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text(
                                    'English',
                                    style: TextStyle(
                                        fontSize: 18, color: theme.accentColor),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text(
                                    'Русский',
                                    style: TextStyle(
                                        fontSize: 18, color: theme.accentColor),
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
                                  size: 30, color: theme.accentColor)
                              : Icon(FeatherIcons.moon,
                                  size: 30, color: Colors.yellowAccent),
                          title: Text(
                            StringUtils.capitalize(AppLocalizations.of(context)
                                .translate('theme')
                                .toString()),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.accentColor),
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
                            activeColor: theme.unselectedWidgetColor,
                            activeTrackColor: theme.colorScheme.surface,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('account')
                        .toString(),
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
