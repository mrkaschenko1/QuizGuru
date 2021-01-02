// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/models/question_model.dart';
import 'package:Quiz_Guru/state_management/cubits/question/question_cubit.dart';

class OneVariant extends StatelessWidget {
  final QuestionModel question;

  const OneVariant({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RadioButtonGroup(
      activeColor: const Color(0xFFFE9D81),
      onSelected: (String selected) => {
        BlocProvider.of<QuestionCubit>(context)
            .showSelectedChoice([int.parse(selected)])
      },
      labels: List<String>.generate(
          question.options.length, (index) => index.toString()),
      picked:
          BlocProvider.of<QuestionCubit>(context).state.currentChoice == null
              ? "0"
              : BlocProvider.of<QuestionCubit>(context)
                  .state
                  .currentChoice[0]
                  .toString(),
      itemBuilder: (Radio rb, Text txt, int i) {
        return GestureDetector(
          onTap: () => BlocProvider.of<QuestionCubit>(context)
              .showSelectedChoice([int.parse(i.toString())]),
          child: Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: <Widget>[
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.accentColor,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    clipBehavior: Clip.hardEdge,
                    child: Transform.scale(
                      scale: 1.7,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: Colors.transparent,
                        ),
                        child: rb,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    question.options[i].text,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.accentColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
