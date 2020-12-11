import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/blocs/login/login_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AuthForm extends StatefulWidget {
  const AuthForm();

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _userEmail = '';
  var _userName = '';
  var _userPass = '';

  void trySubmit(bool isLogin) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      if (isLogin) {
        BlocProvider.of<LoginBloc>(context)
            .add(LoginButtonPressed(email: _userEmail, password: _userPass));
      } else {
        BlocProvider.of<LoginBloc>(context).add(SignUpButtonPressed(
            email: _userEmail, password: _userPass, username: _userName));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget loginForm({@required bool isLogin, bool isLoading = false}) =>
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          Text(
            isLogin
                ? AppLocalizations.of(context)
                    .translate('login_title')
                    .toString()
                : AppLocalizations.of(context)
                    .translate('sign_up_title')
                    .toString(),
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: theme.accentColor),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!isLogin)
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        border: Border.all(width: 2, color: theme.accentColor),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: TextFormField(
                        key: const ValueKey('username'),
                        keyboardType: TextInputType.text,
                        cursorColor: theme.unselectedWidgetColor,
                        style: TextStyle(
                            color: theme.accentColor,
                            fontSize: 20,
                            fontFamily: 'Monserrat',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FeatherIcons.user,
                            size: 24,
                            color: theme.accentColor,
                          ),
                          prefixIconConstraints: BoxConstraints(
                              maxHeight: 24, maxWidth: 50, minWidth: 50),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 15, top: 16, right: 10),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: AppLocalizations.of(context)
                              .translate('username')
                              .toString(),
                          hintStyle: TextStyle(
                              color: theme.unselectedWidgetColor,
                              fontSize: 20,
                              fontFamily: 'Monserrat',
                              fontWeight: FontWeight.w600),
                          errorStyle: const TextStyle(fontSize: 0),
                        ),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return AppLocalizations.of(context)
                                .translate('invalid_username')
                                .toString();
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      border: Border.all(width: 2, color: theme.accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                      key: const ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Theme.of(context).unselectedWidgetColor,
                      style: TextStyle(
                          color: theme.accentColor,
                          fontSize: 20,
                          fontFamily: 'Monserrat',
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          FeatherIcons.mail,
                          size: 24,
                          color: theme.accentColor,
                        ),
                        prefixIconConstraints: BoxConstraints(
                            maxHeight: 24, maxWidth: 50, minWidth: 50),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 15, top: 16, right: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: AppLocalizations.of(context)
                            .translate('email_address')
                            .toString(),
                        hintStyle: TextStyle(
                            color: theme.unselectedWidgetColor,
                            fontSize: 20,
                            fontFamily: 'Monserrat',
                            fontWeight: FontWeight.w600),
                        errorStyle: const TextStyle(fontSize: 0),
                      ),
                      validator: (value) {
                        if (value.isEmpty || !EmailValidator.validate(value)) {
                          return AppLocalizations.of(context)
                              .translate('invalid_email_address')
                              .toString();
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      border: Border.all(width: 2, color: theme.accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                      key: const ValueKey('password'),
                      obscureText: true,
                      cursorColor: Theme.of(context).unselectedWidgetColor,
                      style: TextStyle(
                          color: theme.accentColor,
                          fontSize: 20,
                          fontFamily: 'Monserrat',
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          FeatherIcons.lock,
                          size: 24,
                          color: theme.accentColor,
                        ),
                        prefixIconConstraints: BoxConstraints(
                            maxHeight: 24, maxWidth: 50, minWidth: 50),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 15, top: 16, right: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: AppLocalizations.of(context)
                            .translate('password')
                            .toString(),
                        hintStyle: TextStyle(
                            color: theme.unselectedWidgetColor,
                            fontSize: 20,
                            fontFamily: 'Monserrat',
                            fontWeight: FontWeight.w600),
                        errorStyle: const TextStyle(fontSize: 0),
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return AppLocalizations.of(context)
                              .translate('invalid_password')
                              .toString();
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPass = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (!isLoading)
                        Container(
                            width: double.infinity,
                            child: FlatButton(
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        isLogin
                                            ? AppLocalizations.of(context)
                                                .translate('login_btn')
                                                .toString()
                                                .toUpperCase()
                                            : AppLocalizations.of(context)
                                                .translate('register_btn')
                                                .toString()
                                                .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: theme.primaryColor)),
                                    Icon(
                                      FeatherIcons.chevronRight,
                                      size: 26,
                                      color: theme.primaryColor,
                                    )
                                  ]),
                              onPressed: () => trySubmit(isLogin),
                              color: theme.accentColor,
                            )),
                      if (!isLoading)
                        Container(
                          margin: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('or')
                                .toString(),
                            style: TextStyle(
                                color: theme.accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      if (!isLoading)
                        Container(
                          width: double.infinity,
                          child: FlatButton(
                              padding: const EdgeInsets.all(20),
                              color: theme.colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              onPressed: () =>
                                  BlocProvider.of<LoginBloc>(context)
                                      .add(GoogleSignUpButtonPressed(isLogin)),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('sign_in_with_google_btn')
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              )),
                        ),
                      if (!isLoading)
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                isLogin
                                    ? AppLocalizations.of(context)
                                        .translate('you_are_new')
                                        .toString()
                                    : AppLocalizations.of(context)
                                        .translate('have_account')
                                        .toString(),
                                style: TextStyle(
                                    color: theme.accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              FlatButton(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  isLogin
                                      ? AppLocalizations.of(context)
                                          .translate('create_new_account_btn')
                                          .toString()
                                      : AppLocalizations.of(context)
                                          .translate('switch_to_login_btn')
                                          .toString(),
                                  style: TextStyle(
                                      color: theme.colorScheme.surface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                                onPressed: () {
                                  if (isLogin) {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(ShowSignUpForm());
                                  } else {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(ShowLoginForm());
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      if (isLoading)
                        FittedBox(
                            fit: BoxFit.cover,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                    ],
                  ),
                ],
              ),
            ),
          )
        ]);
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 40, right: 40),
      child: Column(
        children: <Widget>[
          BlocBuilder<LoginBloc, LoginState>(
            builder: (ctx, loginState) {
              if (loginState is LoginInitial || loginState is LoginFormState) {
                return loginForm(isLogin: true);
              } else if (loginState is SignUpFormState) {
                return loginForm(isLogin: false);
              } else if (loginState is LoginLoading) {
                return loginForm(isLogin: loginState.isLogin, isLoading: true);
              }
              return loginForm(isLogin: true);
            },
          ),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.error),
                ));
              }
            },
            child: SizedBox(
              height: 10,
            ),
          ),
        ],
      ),
    );
  }
}
