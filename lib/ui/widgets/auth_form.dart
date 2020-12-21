// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// Project imports:
import '../../app_localizations.dart';
import '../../state_management/blocs/login/login_bloc.dart';
import 'custom_auth_input.dart';

class AuthForm extends StatefulWidget {
  const AuthForm();

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _trySubmit(bool isLogin) {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();
      if (isLogin) {
        BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
          email: _usernameController.text,
          password: _passwordController.text,
        ));
      } else {
        BlocProvider.of<LoginBloc>(context).add(SignUpButtonPressed(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
        ));
      }
    }
  }

  String _usernameValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return AppLocalizations.of(context)
          .translate('invalid_username')
          .toString();
    }
    return null;
  }

  String _passwordValidator(String value) {
    if (value.isEmpty || value.length < 8) {
      return AppLocalizations.of(context)
          .translate('invalid_password')
          .toString();
    }
    return null;
  }

  String _emailValidator(String value) {
    if (value.isEmpty || !EmailValidator.validate(value)) {
      return AppLocalizations.of(context)
          .translate('invalid_email_address')
          .toString();
    }
    return null;
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
                    CustomAuthInput(
                      inputTitle: 'username',
                      theme: theme,
                      controller: _usernameController,
                      validator: _usernameValidator,
                      icon: FeatherIcons.user,
                    ),
                  CustomAuthInput(
                    inputTitle: 'email_address',
                    theme: theme,
                    controller: _emailController,
                    validator: _emailValidator,
                    icon: FeatherIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomAuthInput(
                    inputTitle: 'password',
                    theme: theme,
                    controller: _passwordController,
                    validator: _passwordValidator,
                    icon: FeatherIcons.lock,
                    obscureText: true,
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
                              onPressed: () => _trySubmit(isLogin),
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
