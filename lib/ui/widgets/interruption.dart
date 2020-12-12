// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import '../../app_localizations.dart';
import '../../state_management/cubits/question/question_cubit.dart';

class Interruption extends StatelessWidget {
  final state;

  const Interruption({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(top: 30),
      height: 80,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          state.status != QuestionStatus.loading
              ? GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black, offset: Offset(0, 2))
                        ]),
                    height: 48,
                    width: 48,
                    child: SvgPicture.asset(
                      'assets/images/icons/close_circle_icon.svg',
                      alignment: Alignment.center,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      child: Dialog(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: theme.accentColor, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('are_you_sure')
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: theme.accentColor),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('test_interrupt_dialog_question')
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: theme.accentColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: theme.accentColor,
                                              width: 2),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: FlatButton(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                                    'test_interrupt_dialog_continue')
                                                .toString(),
                                            style: TextStyle(
                                                color: theme.accentColor,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme.accentColor,
                                          border: Border.all(
                                              color: theme.accentColor,
                                              width: 2),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: FlatButton(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                                    'test_interrupt_dialog_finish')
                                                .toString(),
                                            style: TextStyle(
                                                color: theme.primaryColor,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            BlocProvider.of<QuestionCubit>(
                                                    context)
                                                .finishTest(null);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : SizedBox()
        ],
      ),
    );
  }
}
