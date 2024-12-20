import 'package:cheatshield/models/quiz_history_model.dart';
import 'package:cheatshield/services/web/quiz_service.dart';
import 'package:cheatshield/models/quiz_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_provider.g.dart';

@Riverpod(keepAlive: true)
class Quiz extends _$Quiz {
  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;
  late QuizService quizService;

  @override
  QuizResponse? build() {
    quizService = ref.watch(quizServiceProvider.notifier);
    return null;
  }

  Future<QuizResponse?> joinQuiz(String code) async {
    final quizResponse = await quizService.joinQuiz(code);
    if (quizResponse != null) {
      _currentQuestionIndex = 0;
      state = quizResponse;
    }
    return quizResponse;
  }

  void nextQuestion() {
    if (state != null &&
        _currentQuestionIndex < state!.quizSession.quiz.questions.length - 1) {
      _currentQuestionIndex++;
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

  Future<Map<String, dynamic>?> submitAnswer(String answerId) async {
    if (state == null) return null;

    final quizSessionId = state!.quizSession.id;
    final questionId =
        state!.quizSession.quiz.questions[_currentQuestionIndex].id;

    final response = await quizService.submitAnswerForQuestion(
      quizSessionId,
      questionId,
      answerId,
    );

    if (response != null) {
      return response;
    }

    print('Failed to submit answer.');
    return null;
  }

  Future<Map<String, dynamic>?> finishQuizSession() async {
    if (state == null) return null;

    final quizSessionId = state!.quizSession.id;

    final response = await quizService.finishQuizSession(quizSessionId);

    if (response != null) {
      return response;
    }

    print('Failed to finish quiz session.');
    return null;
  }

  Future<List<QuizSessionResult>?> getQuizHistory() async {
    return await quizService.getQuizHistory();
  }
}
