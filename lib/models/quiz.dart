class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizResult {
  final String babId;
  final int score;

  QuizResult({
    required this.babId,
    required this.score,
  });
}
