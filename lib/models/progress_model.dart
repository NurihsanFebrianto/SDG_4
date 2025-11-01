class StudyProgress {
  final String id;
  final String userId;
  final String subject;
  final String currentModule;
  final String currentLesson;
  final int lessonProgress;
  final int dailyCompleted;
  final int weeklyCompleted;
  final int streak;

  StudyProgress({
    required this.id,
    required this.userId,
    required this.subject,
    required this.currentModule,
    required this.currentLesson,
    required this.lessonProgress,
    required this.dailyCompleted,
    required this.weeklyCompleted,
    required this.streak,
  });

  factory StudyProgress.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return StudyProgress(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      currentModule: json['currentModule']?.toString() ?? '',
      currentLesson: json['currentLesson']?.toString() ?? '',
      lessonProgress: safeInt(json['lessonProgress']),
      dailyCompleted: safeInt(json['dailyCompleted']),
      weeklyCompleted: safeInt(json['weeklyCompleted']),
      streak: safeInt(json['streak']),
    );
  }
}
