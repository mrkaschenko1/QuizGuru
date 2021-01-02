// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/app_localizations.dart';
import 'package:Quiz_Guru/injection_container.dart';
import 'package:Quiz_Guru/repositories/user_repository.dart';
import 'package:Quiz_Guru/state_management/blocs/lang/app_langs.dart';
import 'package:Quiz_Guru/state_management/blocs/lang/lang_bloc.dart';
import 'package:Quiz_Guru/state_management/blocs/theme/app_themes.dart';
import 'package:Quiz_Guru/state_management/blocs/theme/theme_bloc.dart';
import 'package:Quiz_Guru/ui/widgets/settings_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _langValue;
  int _themeValue;
  final UserRepository userRepository = sl.get<UserRepository>();

  @override
  void initState() {
    _themeValue = appThemeData.entries
        .firstWhere((MapEntry<AppTheme, dynamic> element) =>
            element.key == BlocProvider.of<ThemeBloc>(context).state.themeName)
        .key
        .index;
    _langValue = appLangData.entries
        .firstWhere((MapEntry<AppLang, Locale> element) =>
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
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            SettingsAppBar(),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                AppLocalizations.of(context).translate('general').toString(),
                style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF656565)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(width: 2),
                  color: theme.cardColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: theme.accentColor, offset: const Offset(0, 2))
                  ]),
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Column(
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
                          StringUtils.capitalize(AppLocalizations.of(context)
                              .translate('language')
                              .toString()),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.accentColor),
                        ),
                        trailing: DropdownButton<int>(
                          dropdownColor: theme.primaryColor,
                          value: _langValue,
                          items: <DropdownMenuItem<int>>[
                            DropdownMenuItem<int>(
                              value: 0,
                              child: Text(
                                'English',
                                style: TextStyle(
                                    fontSize: 18, color: theme.accentColor),
                              ),
                            ),
                            DropdownMenuItem<int>(
                              value: 1,
                              child: Text(
                                'Русский',
                                style: TextStyle(
                                    fontSize: 18, color: theme.accentColor),
                              ),
                            )
                          ],
                          onChanged: (int value) {
                            setState(() {
                              _langValue = value;
                              if (_langValue == AppLang.en.index) {
                                BlocProvider.of<LangBloc>(context)
                                    .add(const LangChanged(lang: AppLang.en));
                              } else {
                                BlocProvider.of<LangBloc>(context)
                                    .add(const LangChanged(lang: AppLang.ru));
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
                          : const Icon(FeatherIcons.moon,
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
                        // ignore: avoid_bool_literals_in_conditional_expressions
                        value: _themeValue == 1 ? true : false,
                        onChanged: (bool value) {
                          setState(() {
                            _themeValue = value == true ? 1 : 0;
                            BlocProvider.of<ThemeBloc>(context).add(
                              ThemeChanged(
                                  theme:
                                      AppTheme.values[value == true ? 1 : 0]),
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
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                AppLocalizations.of(context).translate('account').toString(),
                style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF656565)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: double.infinity,
              child: FlatButton(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFFFE9D81),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  onPressed: () async {
                    final result = await userRepository.logout();
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
                    style: const TextStyle(
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
