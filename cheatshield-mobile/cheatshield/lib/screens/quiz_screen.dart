import 'package:flutter/material.dart';
import '../components/body/quiz/quiz_component.dart';
import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuizComponent();
  }
}
