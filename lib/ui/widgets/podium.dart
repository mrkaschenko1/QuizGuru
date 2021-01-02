// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/ui/widgets/podium_item.dart';

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
    // print(topUsers);
    const baseHeight = 40.0;
    return Container(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PodiumItem(
              height: baseHeight * 1.5,
              place: 2,
              points: topUsers.get(1, 'points') as int,
              userName: topUsers.get(1, 'username') as String,
            ),
            PodiumItem(
              height: baseHeight * 2,
              place: 1,
              points: topUsers.get(0, 'points') as int,
              userName: topUsers.get(0, 'username') as String,
            ),
            PodiumItem(
              height: baseHeight * 1,
              place: 3,
              points: topUsers.get(2, 'points') as int,
              userName: topUsers.get(2, 'username') as String,
            ),
          ],
        ));
  }
}
