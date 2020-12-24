// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../app_localizations.dart';

class CustomAuthInput extends StatelessWidget {
  final ThemeData theme;
  final Function validator;
  final IconData icon;
  final String inputTitle;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomAuthInput({
    Key key,
    this.validator,
    this.keyboardType,
    this.obscureText,
    @required this.theme,
    @required this.icon,
    @required this.inputTitle,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(width: 2, color: theme.accentColor),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          key: ValueKey(inputTitle),
          keyboardType: keyboardType ?? TextInputType.text,
          obscureText: obscureText ?? false,
          cursorColor: theme.unselectedWidgetColor,
          style: TextStyle(
              color: theme.accentColor,
              fontSize: 20,
              fontFamily: 'Monserrat',
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 24,
              color: theme.accentColor,
            ),
            prefixIconConstraints:
                BoxConstraints(maxHeight: 24, maxWidth: 50, minWidth: 50),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 15, top: 16, right: 10),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText:
                AppLocalizations.of(context).translate(inputTitle).toString(),
            hintStyle: TextStyle(
                color: theme.unselectedWidgetColor,
                fontSize: 20,
                fontFamily: 'Monserrat',
                fontWeight: FontWeight.w600),
            errorStyle: const TextStyle(fontSize: 0),
          ),
          controller: controller,
          validator: (value) => validator(value)),
    );
  }
}
