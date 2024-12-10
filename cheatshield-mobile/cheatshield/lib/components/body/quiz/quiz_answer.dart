import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizAnswer extends ConsumerStatefulWidget {
  const QuizAnswer({Key? key}) : super(key: key);

  @override
  _QuizAnswerState createState() => _QuizAnswerState();
}

class _QuizAnswerState extends ConsumerState<QuizAnswer> {
  String? selectedAnswer;

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _submitAnswer() async {
    final quizNotifier = ref.read(quizProvider.notifier);
    // await quizNotifier.submitAnswer(selectedAnswer ?? '');
    // Reset selection after submission
    setState(() {
      selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    final answers = quizState?['answers'] as List<String>? ?? [];

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
                minimumSize: const Size(double.infinity, 50),
                backgroundColor:
                    selectedAnswer == answer ? Colors.blue : Colors.white,
                side: const BorderSide(color: Colors.black),
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
        if (selectedAnswer != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _submitAnswer,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
      ],
    );
  }
}
