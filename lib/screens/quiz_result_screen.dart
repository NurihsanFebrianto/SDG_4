// lib/screens/quiz_result_screen.dart

import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';

class QuizResultScreen extends StatelessWidget {
  final String babId;
  final QuizResult result;
  final List<QuizQuestion> questions;
  final List<int?> answers;

  const QuizResultScreen({
    super.key,
    required this.babId,
    required this.result,
    required this.questions,
    required this.answers,
  });

  double _calculatePercent() {
    final total = questions.length;
    if (total == 0) return 0.0;
    return (result.score / total) * 100.0;
  }

  @override
  Widget build(BuildContext context) {
    final percent = _calculatePercent();
    final percentText = percent.toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Latihan'),
        centerTitle: true,
        automaticallyImplyLeading: false, // non-aktifkan back default
      ),
      body: Column(
        children: [
          // Header skor
          Container(
            width: double.infinity,
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 56),
                const SizedBox(height: 8),
                const Text(
                  'Kamu sudah menyelesaikan latihan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Skor: $percentText%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: percent >= 70 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  percent >= 70 ? 'Lulus 🎉' : 'Belum lulus, coba lagi 💪',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Rekap soal
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                final userAns =
                    (index < answers.length) ? answers[index] : null;
                final correct = q.correctIndex;
                final isCorrect = userAns != null && userAns == correct;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soal ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(q.question),
                        const SizedBox(height: 8),
                        // pilihan
                        Column(
                          children: List.generate(q.options.length, (optIndex) {
                            final isAnswer = optIndex == correct;
                            final isChosen =
                                userAns != null && userAns == optIndex;

                            Color bg;
                            Color border;
                            if (isChosen && isAnswer) {
                              bg = Colors.green.shade200;
                              border = Colors.green.shade700;
                            } else if (isChosen && !isAnswer) {
                              bg = Colors.red.shade200;
                              border = Colors.red.shade700;
                            } else if (isAnswer) {
                              bg = Colors.green.shade100;
                              border = Colors.green.shade400;
                            } else {
                              bg = Colors.grey.shade100;
                              border = Colors.grey.shade300;
                            }

                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: border),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${String.fromCharCode(65 + optIndex)}. ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(child: Text(q.options[optIndex])),
                                ],
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          isCorrect
                              ? '✅ Jawaban kamu benar.'
                              : '❌ Jawaban kamu salah. ${q.explanation}',
                          style: TextStyle(
                            color: isCorrect
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Tombol konfirmasi kembali ke daftar bab
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Konfirmasi & Kembali ke Daftar Bab'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.pop(
                      context); // kembali ke BabListScreen (route sebelumnya)
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
