import 'package:cheatshield/providers/web/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizAnswer extends ConsumerStatefulWidget {
  const QuizAnswer({Key? key}) : super(key: key);

  @override
  ConsumerState<QuizAnswer> createState() => _QuizAnswerState();
}

class _QuizAnswerState extends ConsumerState<QuizAnswer> {
  String? selectedAnswerId;

  void _selectAnswer(String answerId) {
    setState(() {
      selectedAnswerId = answerId;
    });
  }

  void _submitAnswer() async {
    if (selectedAnswerId == null) return;

    final quizNotifier = ref.read(quizProvider.notifier);
    final quizState = ref.read(quizProvider);

    if (quizState == null) return;

    // Simpan jawaban ke server (opsional, implementasikan di sini jika diperlukan)
    // ...

    if (quizNotifier.isLastQuestion()) {
      // Logika submit kuis
      print("Quiz submitted!");
      // Tambahkan navigasi ke layar akhir atau hasil kuis
    } else {
      quizNotifier.nextQuestion(); // Pindah ke pertanyaan berikutnya
      setState(() {
        selectedAnswerId = null; // Reset pilihan jawaban
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizNotifier = ref.watch(quizProvider.notifier);
    final quizState = ref.watch(quizProvider);

    if (quizState == null || quizState.quizSession.quiz.questions.isEmpty) {
      return const Center(child: Text('No answers available'));
    }

    final answers = quizState
        .quizSession.quiz.questions[quizNotifier.currentQuestionIndex].answers;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...answers.map((answer) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () => _selectAnswer(answer.id),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: selectedAnswerId == answer.id
                        ? Colors.blue
                        : Colors.white,
                    border: Border.all(
                      color: selectedAnswerId == answer.id
                          ? Colors.blue
                          : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    answer.content,
                    style: TextStyle(
                      color: selectedAnswerId == answer.id
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedAnswerId != null ? _submitAnswer : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 50),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            quizNotifier.isLastQuestion() ? 'Submit' : 'Next',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
