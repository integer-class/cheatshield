import 'package:flutter/material.dart';

class QuizAnswer extends StatelessWidget {
  const QuizAnswer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final answers = ['Batman', 'Ryan Gosling', 'Spiderman', 'Superman'];
    return Column(
      children: answers.map((answer) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              // Aksi ketika tombol jawaban ditekan
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: Text(
              answer,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        );
      }).toList(),
    );
  }
}
