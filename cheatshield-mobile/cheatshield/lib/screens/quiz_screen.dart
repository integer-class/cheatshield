import 'package:flutter/material.dart';
import '../components/body/quiz/quiz_component.dart';
import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          quizState != null ? quizState.quizSession.quiz.title : 'Quiz',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: const QuizComponent(),
    );
  }
}
