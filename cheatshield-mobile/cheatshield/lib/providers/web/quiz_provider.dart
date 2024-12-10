import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/services/web/quiz_service.dart';

final quizProvider =
    StateNotifierProvider<QuizNotifier, Map<String, dynamic>?>((ref) {
  return QuizNotifier();
});

class QuizNotifier extends StateNotifier<Map<String, dynamic>?> {
  QuizNotifier() : super(null);

  final QuizService _quizService = QuizService();

  Future<Map<String, dynamic>?> joinQuiz(String code, String token) async {
    final response = await _quizService.joinQuiz(code, token);
    state = response;

    if (response != null) {
      // Mendapatkan daftar pertanyaan
      final questions = response['quiz']?['quiz']?['questions'];
      if (questions != null && questions is List) {
        for (var question in questions) {
          print('Question: ${question['content']}');

          // Mendapatkan daftar jawaban
          final answers = question['answers'];
          if (answers != null && answers is List) {
            for (var answer in answers) {
              print(
                  'Answer: ${answer['content']}, Correct: ${answer['is_correct']}');
            }
          } else {
            print('No answers available for this question.');
          }
        }
      } else {
        print('No questions available in the quiz.');
      }
    } else {
      print('Failed to join the quiz.');
    }

    return response;
  }
}
