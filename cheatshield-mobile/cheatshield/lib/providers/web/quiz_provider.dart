import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/services/web/quiz_service.dart';
import 'package:cheatshield/models/quiz_model.dart';

final quizProvider = StateNotifierProvider<QuizNotifier, QuizResponse?>((ref) {
  return QuizNotifier();
});

class QuizNotifier extends StateNotifier<QuizResponse?> {
  QuizNotifier() : super(null);

  final QuizService _quizService = QuizService();

  Future<void> joinQuiz(String code, String token) async {
    final quizResponse = await _quizService.joinQuiz(code, token);
    if (quizResponse != null) {
      state = quizResponse;
      print('Message: ${quizResponse.message}');
      print('Quiz Title: ${quizResponse.quizSession.title}');
      for (var question in quizResponse.quizSession.quiz.questions) {
        print('Question: ${question.content}');
        for (var answer in question.answers) {
          print('Answer: ${answer.content}, Correct: ${answer.isCorrect}');
        }
      }
    } else {
      print('Failed to join the quiz.');
    }
  }
}
