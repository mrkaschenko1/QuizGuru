import 'package:android_guru/models/question_model.dart';
import 'package:flutter/foundation.dart';

class TestModel {
  final id;
  final title;
  final List<QuestionModel> questions;
  final studentsPassed;
  final averageScore;
  final totalPoints;
  final userTries;
  final tries;
  final userBestScore;
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
      questions: questions ?? this.questions,
      studentsPassed: studentsPassed ?? this.studentsPassed,
      averageScore: averageScore ?? this.averageScore,
      userTries: userTries ?? this.userTries,
      tries: tries ?? this.tries,
      userBestScore: userBestScore ?? this.userBestScore,
      totalPoints: totalPoints ?? this.totalPoints,
      title: title ?? this.title,
      isStarting: isStarting ?? this.isStarting
    );
  }

//  TestModel.fromJson(Map<String, dynamic> json)
//      : text = json['text'] as String,
//        options = json['options'] == null
//            ? null
//            : (jsonConverter.jsonDecode(json['options']) as List)
//            .map((i) => OptionModel.fromJson(i))
//            .toList();
}