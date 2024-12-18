import 'package:cheatshield/models/quiz_history_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/services/web/quiz_service.dart';
import 'package:cheatshield/models/quiz_model.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';

final quizProvider = StateNotifierProvider<QuizNotifier, QuizResponse?>((ref) {
  return QuizNotifier(ref);
});

class QuizNotifier extends StateNotifier<QuizResponse?> {
  QuizNotifier(this.ref) : super(null);

  final Ref ref;
  final QuizService _quizService = QuizService();
  int _currentQuestionIndex = 0;

  int get currentQuestionIndex => _currentQuestionIndex;

  Future<void> joinQuiz(String code) async {
    final quizResponse = await _quizService.joinQuiz(code);
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
        userInQuizSession: state!.userInQuizSession,
      );
    }
  }

  bool isLastQuestion() {
    return state != null &&
        _currentQuestionIndex >= state!.quizSession.quiz.questions.length - 1;
  }

  Future<Map<String, dynamic>?> submitAnswer(String answerId) async {
    if (state == null) return null;

    final quizSessionId = state!.quizSession.id;
    final questionId =
        state!.quizSession.quiz.questions[_currentQuestionIndex].id;

    final response = await _quizService.submitAnswerForQuestion(
      quizSessionId,
      questionId,
      answerId,
    );

    if (response != null) {
      return response;
    } else {
      print('Failed to submit answer.');
      return null;
    }
  }

  Future<Map<String, dynamic>?> finishQuizSession() async {
    if (state == null) return null;

    final quizSessionId = state!.quizSession.id;

    final response = await _quizService.finishQuizSession(quizSessionId);

    if (response != null) {
      return response;
    } else {
      print('Failed to finish quiz session.');
      return null;
    }
  }

  // history
  Future<List<QuizHistory>?> getQuizHistory() async {
    final response = await _quizService.getQuizHistory();

    if (response != null) {
      return response;
    } else {
      print('Failed to get quiz history.');
      return null;
    }
  }
}
