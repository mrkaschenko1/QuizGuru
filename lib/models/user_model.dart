// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final int points;
  final int testsPassedCount;
  final int ratingPosition;

  UserModel({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.points,
    @required this.testsPassedCount,
    @required this.ratingPosition,
  });
}
