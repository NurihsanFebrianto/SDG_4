class FeedbackModel {
  final String userId;
  final String babId;
  final int rating; // 1-5
  final String comment;
  final DateTime timestamp;
  final int readingDuration; // in seconds

  FeedbackModel({
    required this.userId,
    required this.babId,
    required this.rating,
    required this.comment,
    required this.timestamp,
    required this.readingDuration,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'babId': babId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
      'readingDuration': readingDuration,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      userId: map['userId'] as String? ?? '',
      babId: map['babId'] as String? ?? '',
      rating: map['rating'] as int? ?? 0,
      comment: map['comment'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
      readingDuration: map['readingDuration'] as int? ?? 0,
    );
  }
}
