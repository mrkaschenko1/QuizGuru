// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/models/question_model.dart';
import 'package:Quiz_Guru/state_management/cubits/question/question_cubit.dart';

class MultipleVariant extends StatelessWidget {
  final QuestionModel question;

  const MultipleVariant({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: CheckboxGroup(
        checkColor: Colors.black,
        activeColor: theme.colorScheme.surface,
        onSelected: (List selected) => {
          BlocProvider.of<QuestionCubit>(context).showSelectedChoice(
              selected.map((dynamic e) => int.parse(e as String)).toList())
        },
        labels: List<String>.generate(
            question.options.length, (index) => index.toString()),
        checked:
            BlocProvider.of<QuestionCubit>(context).state.currentChoice == null
                ? ["0"]
                : BlocProvider.of<QuestionCubit>(context)
                    .state
                    .currentChoice
                    .map((e) => e.toString())
                    .toList(),
        itemBuilder: (Checkbox cb, Text txt, int i) {
          return GestureDetector(
            onTap: () =>
                BlocProvider.of<QuestionCubit>(context).addOrRemoveToChoice(i),
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.accentColor,
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          )),
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        child: Transform.scale(
                          scale: 1.6,
                          child: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.transparent,
                            ),
                            child: cb,
                          ),
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
      ),
    );
  }
}
