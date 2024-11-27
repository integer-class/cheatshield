import 'package:flutter/material.dart';
import 'home_code.dart';
import 'home_quizzes.dart';

class HomeComponent extends StatelessWidget {
  const HomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        HomeCode(),
        SizedBox(height: 20),
        Text(
          'Quizzes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Expanded(
          child: HomeQuizzes(),
        ),
      ],
    );
  }
}
