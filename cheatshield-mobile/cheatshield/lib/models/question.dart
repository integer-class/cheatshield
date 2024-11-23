class Question {
  final int idQuestion;
  final String questionText;
  final List<String> options; // Pilihan jawaban
  final int correctOptionIndex; // Indeks jawaban yang benar

  Question({
    required this.idQuestion,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });
}
