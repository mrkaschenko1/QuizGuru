import 'package:flutter/foundation.dart';

class TestModel {
  final id;
  final title;
  final questions;
  final studentsPassed;
  final averageScore;
  final totalPoints;
  final userTries;
  final userBestScore;
  final bool isStarting;

  TestModel({
    @required this.id,
    @required this.questions,
    @required this.studentsPassed,
    @required this.averageScore,
    @required this.userTries,
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
    int userBestScore,
    int totalPoints,
    String title,
    bool isStarting,
  }) {
    return TestModel(
      id: id ?? this.id,
      questions: questions ?? this.questions,
      studentsPassed: studentsPassed ?? this.studentsPassed,
      averageScore: averageScore ?? this.averageScore,
      userTries: userTries ?? this.userTries,
      userBestScore: userBestScore ?? this.userBestScore,
      totalPoints: totalPoints ?? this.totalPoints,
      title: title ?? this.title,
      isStarting: isStarting ?? this.isStarting
    );
  }
}