import 'package:flutter/material.dart';

class QuizAnswer extends StatefulWidget {
  const QuizAnswer({Key? key}) : super(key: key);

  @override
  _QuizAnswerState createState() => _QuizAnswerState();
}

class _QuizAnswerState extends State<QuizAnswer> {
  final List<String> answers = [
    'Batman',
    'Ryan Gosling',
    'Spiderman',
    'Superman'
  ];
  String? selectedAnswer; // Jawaban yang dipilih

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _nextQuestion() {
    // Logika untuk pertanyaan selanjutnya
    setState(() {
      selectedAnswer = null; // Reset jawaban
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Next question logic goes here!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...answers.map((answer) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                _selectAnswer(answer);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor:
                    selectedAnswer == answer ? Colors.blue : Colors.white,
                side: BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                answer,
                style: TextStyle(
                  color: selectedAnswer == answer ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }).toList(),
        if (selectedAnswer !=
            null) // Tampilkan tombol Next hanya jika ada jawaban yang dipilih
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green, // Warna hijau untuk tombol Next
                side: BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
      ],
    );
  }
}
