class Quiz {
  final String id;
  final String? userId;
  final String quizId;
  final String code;
  final String title;
  final DateTime startedAt;
  final DateTime completedAt;
  final List<Question> questions;

  Quiz({
    required this.id,
    this.userId,
    required this.quizId,
    required this.code,
    required this.title,
    required this.startedAt,
    required this.completedAt,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      userId: json['user_id'],
      quizId: json['quiz_id'],
      code: json['code'],
      title: json['title'],
      startedAt: DateTime.parse(json['started_at']),
      completedAt: DateTime.parse(json['completed_at']),
      questions: (json['quiz']['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class Question {
  final String id;
  final String quizId;
  final String content;
  final int points;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.quizId,
    required this.content,
    required this.points,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      quizId: json['quiz_id'],
      content: json['content'],
      points: json['points'],
      answers:
          (json['answers'] as List).map((a) => Answer.fromJson(a)).toList(),
    );
  }
}

class Answer {
  final String id;
  final String questionId;
  final String content;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.questionId,
    required this.content,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      questionId: json['question_id'],
      content: json['content'],
      isCorrect: json['is_correct'],
    );
  }
}
