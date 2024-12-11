import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizQuestion extends ConsumerWidget {
  const QuizQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    if (quizState == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Loading question...',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.left, // Masih perlu layout memastikan
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: Align(
        // Gunakan Align untuk memastikan posisi Text
        alignment: Alignment.center,
        child: Text(
          quizState.quizSession.quiz.questions[quizState.currentQuestionIndex]
              .content,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
