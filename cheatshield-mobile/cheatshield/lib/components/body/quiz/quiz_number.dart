import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizNumber extends ConsumerWidget {
  const QuizNumber({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.watch(quizProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Text(
          quizState != null
              ? 'Question ${quizNotifier.currentQuestionIndex + 1} of ${quizState.quizSession.quiz.questions.length}'
              : 'Loading...',
          style: const TextStyle(
            fontSize: 14, // Adjust font size to better fit your design
            fontWeight: FontWeight.bold,
            color: Color(0xFF343300), // Accent color
          ),
        ),
      ),
    );
  }
}
