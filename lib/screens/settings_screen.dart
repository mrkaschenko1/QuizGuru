import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/blocs/lang/app_langs.dart';
import 'package:android_guru/blocs/lang/lang_bloc.dart';
import 'package:android_guru/blocs/theme/app_themes.dart';
import 'package:android_guru/blocs/theme/theme_bloc.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _langValue;
  var _themeValue;

  @override
  void initState() {
    _themeValue = appThemeData.entries
        .firstWhere((element) => element.key == BlocProvider.of<ThemeBloc>(context).state.themeName)
        .key
        .index;
    _langValue = appLangData.entries
        .firstWhere((element) => element.value == BlocProvider.of<LangBloc>(context).state.langData)
        .key
        .index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    boxShadow: [BoxShadow(color: Colors.grey)]
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate('preferences').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                        margin: const EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 15),
                        child: ListTile(
                          dense: true,
                          leading: Icon(Icons.color_lens, size: 30,),
                          title: Text(
                            StringUtils.capitalize(AppLocalizations.of(context).translate('theme').toString()),
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: DropdownButton(
                            value: _themeValue,
                            items: [
                              ...appThemeData.map((key, value) =>
                                  MapEntry(key, DropdownMenuItem(
                                    child: Container(
                                      width: 60,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              color: value.primaryColor,
                                              child: SizedBox(width: 20, height: 20,)
                                          ),
                                          Container(
                                              color: value.accentColor ,
                                              child: SizedBox(width: 20, height: 20,)
                                          ),
                                          Container(
                                              color: value.scaffoldBackgroundColor,
                                              child: SizedBox(width: 20, height: 20,)
                                          ),
                                        ],
                                      )
                                    ),
                                    value: key.index,))
                              ).values.toList()
                            ],
                            onChanged: (value) {
                              setState(() {
                                _themeValue = value;
                                BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.values[value]));
                              });
                            },
                          ),
                        )
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                          ),
                          margin: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                          child: ListTile(
                            dense: true,
                            leading: Icon(Icons.language, size: 30,),
                            title: Text(
                              StringUtils.capitalize(AppLocalizations.of(context).translate('language').toString()),
                              style: TextStyle(fontSize: 18),),
                            trailing: DropdownButton(
                              value: _langValue,
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text('English', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Русский', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),),
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _langValue = value;
                                  if (_langValue == AppLang.EN.index) {
                                    BlocProvider.of<LangBloc>(context).add(LangChanged(lang: AppLang.EN));
                                  } else {
                                    BlocProvider.of<LangBloc>(context).add(LangChanged(lang: AppLang.RU));
                                  }
                                });
                              },
                            ),
                          )
                      ),
                    ],
                  ),
                )
              ]
            ),
          )
    );
  }
}

