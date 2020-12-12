// Project imports:
import 'option_model.dart';

enum QuestionType { One, Multiple }

class QuestionModel {
  final String text;
  final List<OptionModel> options;

  QuestionModel(this.text, this.options);

  QuestionModel.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'] as String,
        options = json['options'] == null
            ? null
            : (json['options'])
                .map<OptionModel>((i) => OptionModel.fromJson(i))
                .toList() as List<OptionModel>;

  QuestionType getQuestionType() {
    int counter = 0;
    for (OptionModel option in this.options) {
      if (option.isRight) counter++;
    }
    if (counter > 1) {
      return QuestionType.Multiple;
    }
    return QuestionType.One;
  }
}
