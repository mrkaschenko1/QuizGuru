// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/models/question_model.dart';

class TestModel {
  final String id;
  final String title;
  final List<QuestionModel> questions;
  final int studentsPassed;
  final double averageScore;
  final int totalPoints;
  final int userTries;
  final int tries;
  final int userBestScore;
  final bool isStarting;

  TestModel({
    @required this.id,
    @required this.questions,
    @required this.studentsPassed,
    @required this.averageScore,
    @required this.userTries,
    @required this.tries,
    @required this.userBestScore,
    @required this.totalPoints,
    @required this.title,
    this.isStarting = false,
  });

  TestModel copyWith({
    String id,
    String questions,
    int studentsPassed,
    double averageScore,
    int userTries,
    int tries,
    int userBestScore,
    int totalPoints,
    String title,
    bool isStarting,
  }) {
    return TestModel(
        id: id ?? this.id,
        questions: questions as List<QuestionModel> ?? this.questions,
        studentsPassed: studentsPassed ?? this.studentsPassed,
        averageScore: averageScore ?? this.averageScore,
        userTries: userTries ?? this.userTries,
        tries: tries ?? this.tries,
        userBestScore: userBestScore ?? this.userBestScore,
        totalPoints: totalPoints ?? this.totalPoints,
        title: title ?? this.title,
        isStarting: isStarting ?? this.isStarting);
  }
}
