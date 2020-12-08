import 'package:android_guru/models/test_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TestCard extends StatelessWidget {
  final TestModel test;

  const TestCard({Key key, this.test}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaQueary = MediaQuery.of(context);
    final _size = _mediaQueary.size.width / 2 * 0.88;
    return FlipCard(
      direction: FlipDirection.HORIZONTAL, // default
      front: Container(
        height: _size,
        width: _size,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              test.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${test.questions.length} questions',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    FeatherIcons.info,
                    size: 40,
                  ),
                  padding: EdgeInsets.only(bottom: 15),
                  constraints: BoxConstraints(maxWidth: 40, minWidth: 40),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FeatherIcons.playCircle,
                    size: 40,
                    color: Colors.black,
                  ),
                  padding: EdgeInsets.only(bottom: 15),
                  constraints: BoxConstraints(maxWidth: 40, minWidth: 40),
                )
              ],
            )
          ],
        ),
      ),
      back: Container(
        height: _size,
        width: _size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            color: Colors.white),
        child: Text('Back'),
      ),
    );
  }
}
