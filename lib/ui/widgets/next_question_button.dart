// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/app_localizations.dart';
import 'package:Quiz_Guru/state_management/cubits/question/question_cubit.dart';

class NextQuestionButton extends StatelessWidget {
  const NextQuestionButton({
    Key key,
    @required this.state,
    @required this.theme,
    @required this.onPressedCallback,
  }) : super(key: key);

  final ThemeData theme;
  final QuestionState state;
  final Function onPressedCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FlatButton(
        color: theme.accentColor,
        padding: const EdgeInsets.all(20),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        onPressed: () => onPressedCallback(state, context),
        child: state.status == QuestionStatus.loading
            ? Center(
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    state.test.questions.length > state.currentQuestionInd + 1
                        ? AppLocalizations.of(context)
                            .translate('next_btn')
                            .toString()
                        : AppLocalizations.of(context)
                            .translate('finish_quiz_btn')
                            .toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: theme.primaryColor),
                  ),
                  Icon(
                    FeatherIcons.chevronRight,
                    color: theme.primaryColor,
                  )
                ],
              ),
      ),
    );
  }
}
