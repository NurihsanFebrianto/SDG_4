class QuizResult {
  final String babId;
  final int score;

  QuizResult({
    required this.babId,
    required this.score,
  });

  Map<String, dynamic> toJson() => {
        'babId': babId,
        'score': score,
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      babId: json['babId'] as String,
      score: json['score'] as int,
    );
  }
}
