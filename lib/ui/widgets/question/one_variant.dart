import 'package:android_guru/cubits/question/question_cubit.dart';
import 'package:android_guru/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class OneVariant extends StatelessWidget {
  final QuestionModel question;

  const OneVariant({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioButtonGroup(
      orientation: GroupedButtonsOrientation.VERTICAL,
      margin: const EdgeInsets.only(left: 12.0),
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
        return Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.6),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(0, 0), blurRadius: 0)
              ]),
          child: ListTile(
            leading: rb,
            title: Text(question.options[i].text),
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
