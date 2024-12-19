// To parse this JSON data, do
//
//     final quizResponse = quizResponseFromJson(jsonString);

import 'dart:convert';

QuizResponse quizResponseFromJson(String str) =>
    QuizResponse.fromJson(json.decode(str));

String quizResponseToJson(QuizResponse data) => json.encode(data.toJson());

class QuizResponse {
  String message;
  QuizSession quizSession;
  int currentQuestionIndex;

  QuizResponse({
    required this.message,
    required this.quizSession,
    this.currentQuestionIndex = 0,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) => QuizResponse(
        message: json["message"],
        quizSession: QuizSession.fromJson(json["data"]["quiz_session"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "quiz_session": quizSession.toJson(),
      };
}

class QuizSession {
  String id;
  dynamic userId;
  String quizId;
  String code;
  String title;
  DateTime startedAt;
  DateTime completedAt;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  QuizItem quiz;

  QuizSession({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.code,
    required this.title,
    required this.startedAt,
    required this.completedAt,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.quiz,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) => QuizSession(
        id: json["id"],
        userId: json["user_id"],
        quizId: json["quiz_id"],
        code: json["code"],
        title: json["title"],
        startedAt: DateTime.parse(json["started_at"]),
        completedAt: DateTime.parse(json["completed_at"]),
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        quiz: QuizItem.fromJson(json["quiz"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "quiz_id": quizId,
        "code": code,
        "title": title,
        "started_at": startedAt.toIso8601String(),
        "completed_at": completedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "quiz": quiz.toJson(),
      };
}

class QuizItem {
  String id;
  String userId;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  List<Question> questions;

  QuizItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.questions,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) => QuizItem(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  String id;
  String quizId;
  String content;
  int points;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  List<Answer> answers;

  Question({
    required this.id,
    required this.quizId,
    required this.content,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        quizId: json["quiz_id"],
        content: json["content"],
        points: json["points"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quiz_id": quizId,
        "content": content,
        "points": points,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
      };
}

class Answer {
  String id;
  String questionId;
  String content;
  bool isCorrect;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Answer({
    required this.id,
    required this.questionId,
    required this.content,
    required this.isCorrect,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"],
        questionId: json["question_id"],
        content: json["content"],
        isCorrect: json["is_correct"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "content": content,
        "is_correct": isCorrect,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class UserInQuizSession {
  String userId;
  String quizSessionId;
  String id;
  DateTime updatedAt;
  DateTime createdAt;

  UserInQuizSession({
    required this.userId,
    required this.quizSessionId,
    required this.id,
    required this.updatedAt,
    required this.createdAt,
  });

  factory UserInQuizSession.fromJson(Map<String, dynamic> json) =>
      UserInQuizSession(
        userId: json["user_id"],
        quizSessionId: json["quiz_session_id"],
        id: json["id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );
}
