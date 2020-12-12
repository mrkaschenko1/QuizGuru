// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

// Project imports:
import '../../../models/question_model.dart';
import '../../../state_management/cubits/question/question_cubit.dart';

class OneVariant extends StatelessWidget {
  final QuestionModel question;

  const OneVariant({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RadioButtonGroup(
      activeColor: Color(0xFFFE9D81),
      orientation: GroupedButtonsOrientation.VERTICAL,
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
                        child: rb,
                        data: ThemeData(
                            unselectedWidgetColor: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                SizedBox(
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

    // ListView(children: [
    //   ...(state.test.questions[state.currentQuestionInd].options
    //       .asMap()
    //       .map((optionIndex, option) {
    //         return MapEntry(
    //             optionIndex,
    //             Container(
    //               margin: const EdgeInsets.only(
    //                   left: 20, right: 20, top: 5, bottom: 5),
    //               decoration: BoxDecoration(
    //                   color: Theme.of(context).cardColor.withOpacity(0.6),
    //                   boxShadow: [
    //                     BoxShadow(
    //                         color: Colors.grey,
    //                         offset: Offset(0, 0),
    //                         blurRadius: 0)
    //                   ]),
    //               child: RadioListTile(
    //                 dense: true,
    //                 title: Text(
    //                   option.text,
    //                   style: TextStyle(
    //                     fontSize: 18,
    //                     fontWeight: ((state.currentChoice != null
    //                                 ? state.currentChoice[0]
    //                                 : 0) ==
    //                             optionIndex)
    //                         ? FontWeight.bold
    //                         : FontWeight.normal,
    //                   ),
    //                 ),
    //                 value: optionIndex,
    //                 groupValue: state.currentChoice != null
    //                     ? state.currentChoice[0]
    //                     : 0,
    //                 activeColor: Theme.of(context).colorScheme.secondary,
    //                 onChanged: (value) {
    //                   print(state.currentChoice);
    //                   BlocProvider.of<QuestionCubit>(context)
    //                       .showSelectedChoice(value);
    //                 },
    //               ),
    //             ));
    //       })
    //       .values
    //       .toList())
    // ]);
  }
}
