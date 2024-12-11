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

    final quizState = ref.read(quizProvider);
    if (quizState == null) return;

    // final currentQuestion = quizState.quizSession.quiz.questions[quizState.currentQuestionIndex];

    // TODO: Implement answer submission logic
    // await quizNotifier.submitAnswer(
    //   quizId: quizState.id,
    //   questionId: currentQuestion.id,
    //   answerId: selectedAnswerId!
    // );

    setState(() {
      selectedAnswerId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    if (quizState == null || quizState.quizSession.quiz.questions.isEmpty) {
      return const Center(child: Text('No answers available'));
    }

    // final currentQuestion = quizState.questions[quizState.currentQuestionIndex];
    final answers = quizState.quizSession.quiz.questions[0].answers;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...answers
            .map((answer) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () => _selectAnswer(answer.id),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
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
                              ? Colors.blue
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedAnswerId != null ? _submitAnswer : null,
          child: const Text('Submit Answer'),
        ),
      ],
    );
  }
}
