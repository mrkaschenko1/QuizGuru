// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../ui/widgets/podium_item.dart';

extension SafeLookup on List {
  dynamic get(int index, String key) {
    try {
      return this[index][key];
    } catch (e) {
      return null;
    }
  }
}

class Podium extends StatelessWidget {
  final List<dynamic> topUsers;

  const Podium({
    this.topUsers,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(topUsers);
    final baseHeight = 40.0;
    return Container(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            PodiumItem(
              height: baseHeight * 1.5,
              place: 2,
              points: topUsers.get(1, 'points'),
              userName: topUsers.get(1, 'username'),
            ),
            PodiumItem(
              height: baseHeight * 2,
              place: 1,
              points: topUsers.get(0, 'points'),
              userName: topUsers.get(0, 'username'),
            ),
            PodiumItem(
              height: baseHeight * 1,
              place: 3,
              points: topUsers.get(2, 'points'),
              userName: topUsers.get(2, 'username'),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}
