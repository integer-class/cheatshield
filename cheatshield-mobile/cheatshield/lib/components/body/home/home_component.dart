import 'package:flutter/material.dart';
import 'home_code.dart';
import 'home_quizzes.dart';

class HomeComponent extends StatelessWidget {
  const HomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        HomeCode(), // Input untuk Join Quiz
        SizedBox(height: 20),
        Text(
          'Quizzes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: HomeQuizzes(), // Daftar Quizzes
        ),
      ],
    );
  }
}
