import 'dart:convert';

QuizHistory quizHistoryFromJson(String str) =>
    QuizHistory.fromJson(json.decode(str));

String quizHistoryToJson(QuizHistory data) => json.encode(data.toJson());

class QuizHistory {
  String message;
  List<QuizSessionResult> quizSessionResults;

  QuizHistory({
    required this.message,
    required this.quizSessionResults,
  });

  factory QuizHistory.fromJson(Map<String, dynamic> json) => QuizHistory(
        message: json["message"],
        quizSessionResults: List<QuizSessionResult>.from(
          json["quiz_session_results"].map(
            (x) => QuizSessionResult.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "quiz_session_results":
            List<dynamic>.from(quizSessionResults.map((x) => x.toJson())),
      };
}

class QuizSessionResult {
  String id;
  String userId;
  String quizSessionId;
  int totalScore;
  int correctAnswers;
  int incorrectAnswers;
  String quizTitle;
  DateTime createdAt;
  DateTime updatedAt;

  QuizSessionResult({
    required this.id,
    required this.userId,
    required this.quizSessionId,
    required this.totalScore,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.quizTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuizSessionResult.fromJson(Map<String, dynamic> json) =>
      QuizSessionResult(
        id: json["id"],
        userId: json["user_id"],
        quizSessionId: json["quiz_session_id"],
        totalScore: json["total_score"],
        correctAnswers: json["correct_answers"],
        incorrectAnswers: json["incorrect_answers"],
        quizTitle: json["quiz_title"],
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
        "quiz_title": quizTitle,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
