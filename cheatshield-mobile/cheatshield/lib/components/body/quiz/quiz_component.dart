import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quiz_number.dart';
import 'quiz_question.dart';
import 'quiz_answer.dart';

class QuizComponent extends ConsumerWidget {
  const QuizComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            QuizNumber(),
            SizedBox(height: 20),
            QuizQuestion(),
            SizedBox(height: 20),
            QuizAnswer(),
          ],
        ),
      ),
    );
  }
}
