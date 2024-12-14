import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizQuestion extends ConsumerWidget {
  const QuizQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.watch(quizProvider.notifier);

    if (quizState == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Loading question...',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF343300), // neutral content color
          ),
          textAlign: TextAlign.left,
        ),
      );
    }

    final currentQuestion =
        quizState.quizSession.quiz.questions[quizNotifier.currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          currentQuestion.content,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF343300), // neutral color for the question text
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
