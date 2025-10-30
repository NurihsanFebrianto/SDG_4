class QuizResult {
  final String babId;
  final int score;
  final int totalQuestions;
  final DateTime timestamp;

  QuizResult({
    required this.babId,
    required this.score,
    int? totalQuestions,
    DateTime? timestamp,
  })  : totalQuestions = totalQuestions ?? 5,
        timestamp = timestamp ?? DateTime.now();

  double get percentage =>
      totalQuestions > 0 ? (score / totalQuestions) * 100 : 0.0;

  bool get isPassed => percentage >= 60;

  String get grade {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'E';
  }

  String get status => isPassed ? 'LULUS' : 'TIDAK LULUS';

  Map<String, dynamic> toMap() {
    return {
      'babId': babId,
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      babId: map['babId'] as String,
      score: map['score'] as int,
      totalQuestions: map['totalQuestions'] as int? ?? 5,
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
    );
  }

  QuizResult copyWith({
    String? babId,
    int? score,
    int? totalQuestions,
    DateTime? timestamp,
  }) {
    return QuizResult(
      babId: babId ?? this.babId,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'QuizResult(babId: $babId, score: $score/$totalQuestions, percentage: ${percentage.toStringAsFixed(1)}%, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuizResult &&
        other.babId == babId &&
        other.score == score &&
        other.totalQuestions == totalQuestions &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return babId.hashCode ^
        score.hashCode ^
        totalQuestions.hashCode ^
        timestamp.hashCode;
  }
}
