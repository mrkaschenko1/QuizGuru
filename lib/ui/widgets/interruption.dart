import 'package:android_guru/cubits/question/question_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_localizations.dart';

class Interruption extends StatelessWidget {
  final state;

  const Interruption({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, right: 10, left: 10),
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
                        elevation: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(AppLocalizations.of(context)
                                  .translate('test_interrupt_dialog_question')
                                  .toString()),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate(
                                            'test_interrupt_dialog_continue')
                                        .toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate(
                                            'test_interrupt_dialog_finish')
                                        .toString(),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    BlocProvider.of<QuestionCubit>(context)
                                        .finishTest(null);
                                  },
                                ),
                              ],
                            )
                          ],
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
