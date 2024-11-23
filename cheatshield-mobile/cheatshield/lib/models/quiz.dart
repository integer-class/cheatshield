import 'package:cheatshield/models/question.dart';

class Quiz {
  final int idQuiz;
  final String title;
  final String code;
  final String description;
  final String publishedAt;
  final String validUntil;
  final int timeLimit;
  final List<Question> questions;

  Quiz({
    required this.idQuiz,
    required this.title,
    required this.code,
    required this.description,
    required this.publishedAt,
    required this.validUntil,
    required this.timeLimit,
    required this.questions,
  });
}
