// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class OptionModel {
  final String text;
  final bool isRight;

  OptionModel({@required this.text, @required this.isRight});

  OptionModel.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'] as String,
        isRight = json['right'] as bool;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
        'right': isRight,
      };
}
