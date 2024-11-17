import 'package:flutter/material.dart';
import '../components/body/quiz/quiz_component.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const QuizComponent(),
    );
  }
}
