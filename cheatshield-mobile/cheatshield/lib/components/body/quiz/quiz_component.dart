import 'package:flutter/material.dart';
import 'quiz_number.dart';
import 'quiz_question.dart';
import 'quiz_answer.dart';

class QuizComponent extends StatelessWidget {
  const QuizComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // Added SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            QuizNumber(), // Menampilkan nomor soal
            SizedBox(height: 20),
            QuizQuestion(), // Menampilkan pertanyaan
            SizedBox(height: 20),
            QuizAnswer(), // Menampilkan pilihan jawaban
          ],
        ),
      ),
    );
  }
}
