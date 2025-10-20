import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';

class QuizResultScreen extends StatelessWidget {
  final String babId;
  final String babNama;
  final QuizResult result;
  final List<QuizQuestion> questions;
  final List<int?> answers;
  final VoidCallback onRetakeQuiz;

  const QuizResultScreen({
    super.key,
    required this.babId,
    required this.babNama,
    required this.result,
    required this.questions,
    required this.answers,
    required this.onRetakeQuiz,
  });

  double _calculatePercent() {
    final total = questions.length;
    if (total == 0) return 0.0;
    return (result.score / total) * 100.0;
  }

  @override
  Widget build(BuildContext context) {
    final percent = _calculatePercent();
    final isPassed = percent >= 60;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Quiz - $babNama'),
      ),
      body: Column(
        children: [
          // Header Score
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: isPassed ? Colors.green.shade50 : Colors.orange.shade50,
            ),
            child: Column(
              children: [
                Icon(
                  isPassed ? Icons.emoji_events : Icons.auto_mode,
                  color: isPassed ? Colors.amber : Colors.orange,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  isPassed ? 'Selamat! 🎉' : 'Tetap Semangat! 💪',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Skor: ${result.score}/${questions.length}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isPassed
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                  ),
                ),
                Text(
                  '(${percent.toStringAsFixed(0)}%)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Ulangi Quiz'),
                    onPressed: onRetakeQuiz,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text('Lihat Detail'),
                    onPressed: () {
                      _showDetailedResult(context);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Quick Summary
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                final userAnswer = answers[index];
                final isCorrect = userAnswer == q.correctIndex;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCorrect ? Colors.green : Colors.red,
                      child: Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      'Soal ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      isCorrect ? 'Benar' : 'Salah - ${q.explanation}',
                      style: TextStyle(
                        color: isCorrect
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                    trailing: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailedResult(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              const Text(
                'Detail Hasil Quiz',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    final userAnswer = answers[index];
                    final isCorrect = userAnswer == q.correctIndex;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Soal ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(q.question),
                            const SizedBox(height: 12),
                            ...List.generate(q.options.length, (optIndex) {
                              final isSelected = userAnswer == optIndex;
                              final isCorrectAnswer =
                                  q.correctIndex == optIndex;

                              Color bgColor = Colors.grey.shade100;
                              if (isSelected && isCorrectAnswer) {
                                bgColor = Colors.green.shade100;
                              } else if (isSelected && !isCorrectAnswer) {
                                bgColor = Colors.red.shade100;
                              } else if (isCorrectAnswer) {
                                bgColor = Colors.green.shade100;
                              }

                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected || isCorrectAnswer
                                        ? bgColor.darken(0.2)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${String.fromCharCode(65 + optIndex)}. ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(child: Text(q.options[optIndex])),
                                    if (isSelected && isCorrectAnswer)
                                      const Icon(Icons.check,
                                          color: Colors.green, size: 16),
                                    if (isSelected && !isCorrectAnswer)
                                      const Icon(Icons.close,
                                          color: Colors.red, size: 16),
                                    if (!isSelected && isCorrectAnswer)
                                      const Icon(Icons.check,
                                          color: Colors.green, size: 16),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            if (!isCorrect)
                              Text(
                                'Penjelasan: ${q.explanation}',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),
                              ),
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
}

// Extension untuk darken color
extension ColorExtension on Color {
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
