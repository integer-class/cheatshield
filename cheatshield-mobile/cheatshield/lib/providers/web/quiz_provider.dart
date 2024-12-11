import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/services/web/quiz_service.dart';
import 'package:cheatshield/models/quiz_model.dart';

final quizProvider = StateNotifierProvider<QuizNotifier, QuizResponse?>((ref) {
  return QuizNotifier();
});

class QuizNotifier extends StateNotifier<QuizResponse?> {
  QuizNotifier() : super(null);

  final QuizService _quizService = QuizService();
  int _currentQuestionIndex = 0;

  int get currentQuestionIndex => _currentQuestionIndex;

  Future<void> joinQuiz(String code, String token) async {
    final quizResponse = await _quizService.joinQuiz(code, token);
    if (quizResponse != null) {
      _currentQuestionIndex = 0;
      state = quizResponse;
    } else {
      print('Failed to join the quiz.');
    }
  }

  void nextQuestion() {
    if (state != null &&
        _currentQuestionIndex < state!.quizSession.quiz.questions.length - 1) {
      _currentQuestionIndex++;
      // Force state update by creating new instance
      state = QuizResponse(
        message: state!.message,
        quizSession: state!.quizSession,
      );
    }
  }

  bool isLastQuestion() {
    return state != null &&
        _currentQuestionIndex >= state!.quizSession.quiz.questions.length - 1;
  }
}
