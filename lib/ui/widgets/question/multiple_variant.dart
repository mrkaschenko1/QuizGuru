import 'package:android_guru/cubits/question/question_cubit.dart';
import 'package:android_guru/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class MultipleVariant extends StatelessWidget {
  final QuestionModel question;

  const MultipleVariant({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxGroup(
      orientation: GroupedButtonsOrientation.VERTICAL,
      margin: const EdgeInsets.only(left: 12.0),
      onSelected: (List selected) => {
        BlocProvider.of<QuestionCubit>(context)
            .showSelectedChoice(selected.map((e) => int.parse(e)).toList())
      },
      labels: List<String>.generate(
          question.options.length, (index) => index.toString()),
      checked:
          BlocProvider.of<QuestionCubit>(context).state.currentChoice == null
              ? "0"
              : BlocProvider.of<QuestionCubit>(context)
                  .state
                  .currentChoice
                  .map((e) => e.toString())
                  .toList(),
      itemBuilder: (Checkbox cb, Text txt, int i) {
        return Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.6),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(0, 0), blurRadius: 0)
              ]),
          child: ListTile(
            leading: cb,
            title: Text(question.options[i].text),
          ),
        );
      },
    );
  }
}
