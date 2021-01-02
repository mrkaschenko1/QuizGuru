// 🌎 Project imports:
import 'package:Quiz_Guru/models/option_model.dart';

enum QuestionType { one, multiple }

class QuestionModel {
  final String text;
  final List<OptionModel> options;

  QuestionModel(this.text, this.options);

  QuestionModel.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'] as String,
        options = json['options'] == null
            ? null
            : (json['options'])
                .map<OptionModel>(
                    (Map<dynamic, dynamic> i) => OptionModel.fromJson(i))
                .toList() as List<OptionModel>;

  QuestionType getQuestionType() {
    var counter = 0;
    for (final option in options) {
      if (option.isRight) counter++;
    }
    if (counter > 1) {
      return QuestionType.multiple;
    }
    return QuestionType.one;
  }
}
