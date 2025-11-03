import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../providers/quiz_provider.dart';

class QuizResultScreen extends StatelessWidget {
  final String babId;
  final String babNama;
  final QuizResult result;
  final List<QuizQuestion> questions;
  final List<int?> answers;

  const QuizResultScreen({
    super.key,
    required this.babId,
    required this.babNama,
    required this.result,
    required this.questions,
    required this.answers,
  });

  double _calculatePercent() {
    final total = questions.length;
    if (total == 0) return 0.0;
    return (result.score / total) * 100.0;
  }

  String _getGrade(double percent) {
    if (percent >= 90) return 'A';
    if (percent >= 80) return 'B+';
    if (percent >= 70) return 'B';
    if (percent >= 60) return 'C+';
    if (percent >= 50) return 'C';
    return 'D';
  }

  Color _getGradeColor(double percent) {
    if (percent >= 80) return successGreen;
    if (percent >= 60) return secondaryBlue;
    if (percent >= 50) return accentOrange;
    return errorRed;
  }

  String _getPerformanceText(double percent) {
    if (percent >= 80) return 'Luar Biasa!';
    if (percent >= 60) return 'Bagus!';
    if (percent >= 50) return 'Cukup';
    return 'Perlu Belajar Lagi';
  }

  IconData _getPerformanceIcon(double percent) {
    if (percent >= 80) return Icons.emoji_events_rounded;
    if (percent >= 60) return Icons.thumb_up_rounded;
    if (percent >= 50) return Icons.sentiment_satisfied_rounded;
    return Icons.sentiment_dissatisfied_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final percent = _calculatePercent();
    final isPassed = percent >= 60;
    final grade = _getGrade(percent);
    final gradeColor = _getGradeColor(percent);
    final performanceText = _getPerformanceText(percent);
    final performanceIcon = _getPerformanceIcon(percent);
    final correctCount = result.score;
    final wrongCount = questions.length - result.score;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hasil Quiz Akademik',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              babNama,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: primaryDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Score Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isPassed
                      ? [successGreen, Color(0xFF059669)]
                      : [accentOrange, Color(0xFFEA580C)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (isPassed ? successGreen : accentOrange)
                        .withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Performance Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      performanceIcon,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    performanceText,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    babNama,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Score Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${percent.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          '%',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Grade Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Grade: $grade • ${correctCount}/${questions.length} Benar',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Statistics Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildAcademicStatCard(
                      icon: Icons.check_circle_rounded,
                      label: 'Benar',
                      value: correctCount.toString(),
                      color: successGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAcademicStatCard(
                      icon: Icons.cancel_rounded,
                      label: 'Salah',
                      value: wrongCount.toString(),
                      color: errorRed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAcademicStatCard(
                      icon: Icons.quiz_rounded,
                      label: 'Total',
                      value: questions.length.toString(),
                      color: secondaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back, size: 22),
                      label: const Text(
                        'Kembali',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gradeColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.assignment_rounded, size: 22),
                      label: const Text(
                        'Lihat Pembahasan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: gradeColor,
                        side: BorderSide(color: gradeColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _showDetailedResult(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Summary Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ringkasan Jawaban',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: primaryDarkBlue,
                    ),
                  ),
                  Text(
                    '$correctCount/${questions.length} Benar',
                    style: TextStyle(
                      fontSize: 14,
                      color: neutralGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Quick Summary List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                final userAnswer = answers[index];
                final isCorrect = userAnswer == q.correctIndex;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCorrect
                          ? successGreen.withOpacity(0.3)
                          : errorRed.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? successGreen.withOpacity(0.1)
                            : errorRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCorrect ? Icons.check_rounded : Icons.close_rounded,
                        color: isCorrect ? successGreen : errorRed,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Soal ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: primaryDarkBlue,
                      ),
                    ),
                    subtitle: Text(
                      q.question.length > 60
                          ? '${q.question.substring(0, 60)}...'
                          : q.question,
                      style: TextStyle(
                        color: neutralGray,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: neutralGray,
                    ),
                    onTap: () {
                      _showQuestionDetail(context, index);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      shadowColor: color.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: neutralGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuestionDetail(BuildContext context, int index) {
    final q = questions[index];
    final userAnswer = answers[index];
    final isCorrect = userAnswer == q.correctIndex;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? successGreen.withOpacity(0.1)
                            : errorRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? successGreen : errorRed,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Soal ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: primaryDarkBlue,
                            ),
                          ),
                          Text(
                            isCorrect ? 'Jawaban Benar' : 'Jawaban Salah',
                            style: TextStyle(
                              color: isCorrect ? successGreen : errorRed,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: neutralGray),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      const Text(
                        'Pertanyaan:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: neutralGray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        q.question,
                        style: const TextStyle(
                          fontSize: 16,
                          color: primaryDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Options
                      const Text(
                        'Pilihan Jawaban:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: neutralGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(q.options.length, (optIndex) {
                        final isSelected = userAnswer == optIndex;
                        final isCorrectAnswer = q.correctIndex == optIndex;

                        Color bgColor = Colors.grey.shade50;
                        Color borderColor = Colors.grey.shade200;

                        if (isCorrectAnswer) {
                          bgColor = successGreen.withOpacity(0.1);
                          borderColor = successGreen.withOpacity(0.3);
                        }
                        if (isSelected && !isCorrectAnswer) {
                          bgColor = errorRed.withOpacity(0.1);
                          borderColor = errorRed.withOpacity(0.3);
                        }

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isCorrectAnswer
                                      ? successGreen
                                      : (isSelected && !isCorrectAnswer)
                                          ? errorRed
                                          : Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + optIndex),
                                    style: TextStyle(
                                      color: isCorrectAnswer ||
                                              (isSelected && !isCorrectAnswer)
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  q.options[optIndex],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: primaryDarkBlue,
                                  ),
                                ),
                              ),
                              if (isCorrectAnswer)
                                Icon(
                                  Icons.check_circle,
                                  color: successGreen,
                                  size: 20,
                                ),
                              if (isSelected && !isCorrectAnswer)
                                Icon(
                                  Icons.cancel,
                                  color: errorRed,
                                  size: 20,
                                ),
                            ],
                          ),
                        );
                      }),

                      // User Answer Status
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? successGreen.withOpacity(0.1)
                              : errorRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCorrect
                                ? successGreen.withOpacity(0.3)
                                : errorRed.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.info,
                              color: isCorrect ? successGreen : errorRed,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isCorrect
                                    ? 'Jawaban Anda benar!'
                                    : 'Jawaban Anda salah. Jawaban benar: ${String.fromCharCode(65 + q.correctIndex)}',
                                style: TextStyle(
                                  color: isCorrect ? successGreen : errorRed,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Explanation (jika ada)
                      if (q.explanation != null &&
                          q.explanation!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: secondaryCyan.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: secondaryCyan.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: secondaryCyan,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Penjelasan:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: secondaryCyan,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      q.explanation!,
                                      style: const TextStyle(
                                        color: primaryDarkBlue,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetailedResult(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.assignment_rounded,
                          color: primaryBlue, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Pembahasan Lengkap',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: primaryDarkBlue,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: neutralGray),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Performance Summary
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAcademicMiniStat(
                      'Benar',
                      result.score.toString(),
                      successGreen,
                    ),
                    _buildAcademicMiniStat(
                      'Salah',
                      (questions.length - result.score).toString(),
                      errorRed,
                    ),
                    _buildAcademicMiniStat(
                      'Nilai',
                      '${_calculatePercent().toStringAsFixed(0)}%',
                      secondaryBlue,
                    ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    final userAnswer = answers[index];
                    final isCorrect = userAnswer == q.correctIndex;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCorrect
                              ? successGreen.withOpacity(0.3)
                              : errorRed.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? successGreen.withOpacity(0.1)
                                        : errorRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: isCorrect ? successGreen : errorRed,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Soal ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: primaryDarkBlue,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  isCorrect ? 'Benar' : 'Salah',
                                  style: TextStyle(
                                    color: isCorrect ? successGreen : errorRed,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Question
                            Text(
                              q.question,
                              style: const TextStyle(
                                fontSize: 15,
                                color: primaryDarkBlue,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Options
                            ...List.generate(q.options.length, (optIndex) {
                              final isSelected = userAnswer == optIndex;
                              final isCorrectAnswer =
                                  q.correctIndex == optIndex;

                              Color bgColor = Colors.grey.shade50;
                              Color borderColor = Colors.grey.shade200;

                              if (isCorrectAnswer) {
                                bgColor = successGreen.withOpacity(0.1);
                                borderColor = successGreen.withOpacity(0.3);
                              }
                              if (isSelected && !isCorrectAnswer) {
                                bgColor = errorRed.withOpacity(0.1);
                                borderColor = errorRed.withOpacity(0.3);
                              }

                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isCorrectAnswer
                                            ? successGreen
                                            : (isSelected && !isCorrectAnswer)
                                                ? errorRed
                                                : Colors.grey.shade300,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(65 + optIndex),
                                          style: TextStyle(
                                            color: isCorrectAnswer ||
                                                    (isSelected &&
                                                        !isCorrectAnswer)
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        q.options[optIndex],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: primaryDarkBlue,
                                        ),
                                      ),
                                    ),
                                    if (isCorrectAnswer)
                                      Icon(
                                        Icons.check_circle,
                                        color: successGreen,
                                        size: 18,
                                      ),
                                    if (isSelected && !isCorrectAnswer)
                                      Icon(
                                        Icons.cancel,
                                        color: errorRed,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              );
                            }),

                            // Explanation
                            if (q.explanation != null &&
                                q.explanation!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: secondaryCyan.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: secondaryCyan.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: secondaryCyan,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Penjelasan:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: secondaryCyan,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            q.explanation!,
                                            style: const TextStyle(
                                              color: primaryDarkBlue,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAcademicMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: neutralGray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Academic Color Scheme Constants
const Color primaryDarkBlue = Color(0xFF0A3D62);
const Color primaryBlue = Color(0xFF1E3A8A);
const Color primaryLightBlue = Color(0xFF0D47A1);

const Color secondaryCyan = Color(0xFF0EA5E9);
const Color secondaryBlue = Color(0xFF0284C7);
const Color secondaryTeal = Color(0xFF14B8A6);

const Color accentAmber = Color(0xFFFBBF24);
const Color accentOrange = Color(0xFFF59E0B);

const Color successGreen = Color(0xFF10B981);
const Color warningYellow = Color(0xFFF59E0B);
const Color errorRed = Color(0xFFEF4444);
const Color neutralGray = Color(0xFF6B7280);
