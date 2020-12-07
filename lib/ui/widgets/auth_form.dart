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
    Widget loginForm({@required bool isLogin, bool isLoading = false}) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sign in',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w900),
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
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: TextFormField(
                        key: const ValueKey('email'),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Theme.of(context).unselectedWidgetColor,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Monserrat',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FeatherIcons.mail,
                            size: 24,
                            color: Colors.black,
                          ),
                          prefixIconConstraints: BoxConstraints(
                              maxHeight: 24, maxWidth: 50, minWidth: 50),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 15, top: 16, right: 10),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontFamily: 'Monserrat',
                              fontWeight: FontWeight.w600),
                          errorStyle: const TextStyle(fontSize: 0),
                        ),
                        validator: (value) {
                          if (value.isEmpty ||
                              !EmailValidator.validate(value)) {
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
                    if (!isLogin)
                      Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          const BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1, 0),
                              blurRadius: 2),
                          const BoxShadow(
                              color: Colors.grey,
                              offset: Offset(-1, 0),
                              blurRadius: 2)
                        ]),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          key: const ValueKey('username'),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate('username')
                                .toString(),
                            labelStyle: TextStyle(
                                color: Theme.of(context).unselectedWidgetColor),
                            errorStyle: const TextStyle(fontSize: 12),
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length <= 4) {
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
                        color: Colors.white,
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: TextFormField(
                        key: const ValueKey('password'),
                        obscureText: true,
                        cursorColor: Theme.of(context).unselectedWidgetColor,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Monserrat',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(bottom: 20, top: 0),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Monserrat',
                                fontWeight: FontWeight.w600),
                            prefixIcon: Icon(
                              FeatherIcons.lock,
                              size: 24,
                              color: Colors.black,
                            ),
                            labelText: AppLocalizations.of(context)
                                .translate('password')
                                .toString(),
                            errorStyle: const TextStyle(fontSize: 0),
                            focusColor: Theme.of(context).cardColor),
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
                    if (!isLoading)
                      Container(
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text(
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
                                    fontSize: 17,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background)),
                            onPressed: () => trySubmit(isLogin),
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    if (!isLoading)
                      FlatButton(
                        child: Text(
                          isLogin
                              ? AppLocalizations.of(context)
                                  .translate('create_new_account_btn')
                                  .toString()
                              : AppLocalizations.of(context)
                                  .translate('switch_to_login_btn')
                                  .toString(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
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
                    if (!isLoading)
                      Text(
                        AppLocalizations.of(context).translate('or').toString(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                            height: 0.4),
                      ),
                    if (!isLoading)
                      Container(
                        child: RaisedButton.icon(
                            elevation: 2,
                            color: Theme.of(context).cardColor,
                            onPressed: () => BlocProvider.of<LoginBloc>(context)
                                .add(GoogleSignUpButtonPressed(isLogin)),
                            icon: Image.asset(
                              'assets/images/google_logo.png',
                              height: 20,
                            ),
                            label: Text(
                              AppLocalizations.of(context)
                                  .translate('sign_in_with_google_btn')
                                  .toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    if (isLoading)
                      FittedBox(
                          fit: BoxFit.cover,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ))
                  ],
                ),
              ),
            ),
          ],
        );
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
