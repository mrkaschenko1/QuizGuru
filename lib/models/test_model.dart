import 'package:flutter/cupertino.dart';

class TestModel {
  final id;
  final title;
  final questions;
  final studentsPassed;
  final averageScore;
  final totalPoints;
  final userTries;
  final userBestScore;

  TestModel({
    @required this.id,
    @required this.questions,
    @required this.studentsPassed,
    @required this.averageScore,
    @required this.userTries,
    @required this.userBestScore,
    @required this.totalPoints,
    @required this.title
  });
}