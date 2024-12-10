import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quiz_number.dart';
import 'quiz_question.dart';
import 'quiz_answer.dart';

class QuizComponent extends ConsumerWidget {
  const QuizComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (quizState != null)
              Text('Joined Quiz: ${quizState['quiz'] ?? 'Unknown'}'),
            const SizedBox(height: 20),
            const QuizNumber(),
            const SizedBox(height: 20),
            const QuizQuestion(),
            const SizedBox(height: 20),
            const QuizAnswer(),
          ],
        ),
      ),
    );
  }
}
