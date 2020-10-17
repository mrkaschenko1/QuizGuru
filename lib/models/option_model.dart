import 'package:flutter/material.dart';

class OptionModel {
  final String text;
  final bool isRight;

  OptionModel({@required this.text, @required this.isRight});

  OptionModel.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'] as String,
        isRight = json['isRight'] as bool;

  Map<String, dynamic> toJson() =>
      {
        'text': text,
        'isRight': isRight,
      };
}