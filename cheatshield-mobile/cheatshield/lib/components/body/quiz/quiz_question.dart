import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizQuestion extends ConsumerWidget {
  const QuizQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    // Handle loading/null state
    if (quizState == null || quizState.quizSession.quiz.questions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.black),
        ),
        child: const Center(
          child: Text(
            'Loading question...',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Get current question based on index
    final currentQuestionIndex = 0; // TODO: Track this in QuizState
    final currentQuestion =
        quizState.quizSession.quiz.questions[currentQuestionIndex];
    final questionContent = currentQuestion.content;

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          questionContent,
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
