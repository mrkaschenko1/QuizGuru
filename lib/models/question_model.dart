import 'package:android_guru/models/option_model.dart';

class QuestionModel {
  final String text;
  final List<OptionModel> options;

  QuestionModel(this.text, this.options);

  QuestionModel.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'] as String,
        options = json['options'] == null
                  ? null
                  : (json['options'])
                      .map<OptionModel>((i) => OptionModel.fromJson(i)).toList() as List<OptionModel>;
}