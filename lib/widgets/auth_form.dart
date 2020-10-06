import 'package:android_guru/app_localizations.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AuthForm extends StatefulWidget {
  final void Function({String email, String username, String password, bool isLogin, BuildContext ctx}) submitForm;
  final void Function(BuildContext ctx) signInWithGoogle;
  final bool isLoading;

  const AuthForm(this.submitForm, this.signInWithGoogle, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPass = '';

  void trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitForm(email: _userEmail, username: _userName, password: _userPass, isLogin: _isLogin, ctx: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 60, left: 25, right: 25),
        child: Column(
            children: <Widget>[
              Image.asset('assets/images/android_head.svg', width: double.infinity,),
              Container(
                margin: const EdgeInsets.only(top: 0,),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                const BoxShadow(color: Colors.grey, offset: Offset(1, 0), blurRadius: 2),
                                const BoxShadow(color: Colors.grey, offset: Offset(-1, 0), blurRadius: 2)
                              ]
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            key: const ValueKey('email'),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Theme.of(context).unselectedWidgetColor,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).translate('email_address').toString(),
                              labelStyle: TextStyle(color: Theme.of(context).unselectedWidgetColor),
                              errorStyle: const TextStyle(fontSize: 12),
                              focusColor: Theme.of(context).cardColor
                            ),
                            validator: (value) {
                              if (value.isEmpty || !EmailValidator.validate(value)) {
                                return AppLocalizations.of(context).translate('invalid_email_address').toString();
                              }
                              return null;
                            },
                            onSaved: (value) {
                                _userEmail = value;
                            },
                          ),
                        ),
                        if (!_isLogin) Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                const BoxShadow(color: Colors.grey, offset: Offset(1, 0), blurRadius: 2),
                                const BoxShadow(color: Colors.grey, offset: Offset(-1, 0), blurRadius: 2)
                              ]
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            key: const ValueKey('username'),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).translate('username').toString(),
                              labelStyle: TextStyle(color: Theme.of(context).unselectedWidgetColor),
                              errorStyle: const TextStyle(fontSize: 12),
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length <= 4) {
                                return AppLocalizations.of(context).translate('invalid_username').toString();
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userName = value;
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                const BoxShadow(color: Colors.grey, offset: Offset(1, 0), blurRadius: 2),
                                const BoxShadow(color: Colors.grey, offset: Offset(-1, 0), blurRadius: 2)
                              ]
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            key: const ValueKey('password'),
                            obscureText: true,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(fontSize: 12),
                              labelText: AppLocalizations.of(context).translate('password').toString(),
                              labelStyle: TextStyle(color: Theme.of(context).unselectedWidgetColor),
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length < 8) {
                                return AppLocalizations.of(context).translate('invalid_password').toString();
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userPass = value;
                            },
                          ),
                        ),
                        if (widget.isLoading) CircularProgressIndicator(),
                        if (!widget.isLoading)
                          Container(
                            width: double.infinity,
                            child: RaisedButton(
                              child: Text(
                                  _isLogin ?
                                  AppLocalizations.of(context).translate('login_btn').toString().toUpperCase() :
                                  AppLocalizations.of(context).translate('register_btn').toString().toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4,
                                      color: Theme.of(context).colorScheme.background)
                              ),
                              onPressed: trySubmit,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          ),
                        if (!widget.isLoading)
                          FlatButton(
                            child: Text(
                              _isLogin ?
                              AppLocalizations.of(context).translate('create_new_account_btn').toString() :
                              AppLocalizations.of(context).translate('switch_to_login_btn').toString(),
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },),
                        if (!widget.isLoading) Text(AppLocalizations.of(context).translate('or').toString(), style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14, height: 0.4),),
                        if (!widget.isLoading) Container(
                          child: RaisedButton.icon(
                            elevation: 2,
                              color: Theme.of(context).cardColor,
                              onPressed: () => widget.signInWithGoogle(context),
                              icon: Image.asset('assets/images/google_logo.png', height: 20,),
                              label: Text(AppLocalizations.of(context).translate('sign_in_with_google_btn').toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold,),)
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
