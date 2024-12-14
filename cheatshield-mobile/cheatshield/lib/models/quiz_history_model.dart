// To parse this JSON data, do
//
//     final quizResponse = quizResponseFromJson(jsonString);

import 'dart:convert';

QuizHistory quizHistoryFromJson(String str) =>
    QuizHistory.fromJson(json.decode(str));

String quizHistoryToJson(QuizHistory data) => json.encode(data.toJson());

class QuizHistory {
  String id;
  String userId;
  String quizSessionId;
  int totalScore;
  int correctAnswers;
  int incorrectAnswers;
  dynamic cheatingStatus;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  QuizHistory({
    required this.id,
    required this.userId,
    required this.quizSessionId,
    required this.totalScore,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.cheatingStatus,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuizHistory.fromJson(Map<String, dynamic> json) => QuizHistory(
        id: json["id"],
        userId: json["user_id"],
        quizSessionId: json["quiz_session_id"],
        totalScore: json["total_score"],
        correctAnswers: json["correct_answers"],
        incorrectAnswers: json["incorrect_answers"],
        cheatingStatus: json["cheating_status"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "quiz_session_id": quizSessionId,
        "total_score": totalScore,
        "correct_answers": correctAnswers,
        "incorrect_answers": incorrectAnswers,
        "cheating_status": cheatingStatus,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
