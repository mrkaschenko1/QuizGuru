// Flutter imports:
import 'package:flutter/foundation.dart';

class UserModel {
  final id;
  final username;
  final email;
  final points;
  final testsPassedCount;
  final ratingPosition;

  UserModel({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.points,
    @required this.testsPassedCount,
    @required this.ratingPosition
  });
}
