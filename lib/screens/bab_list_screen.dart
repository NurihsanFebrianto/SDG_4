import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/modul.dart'; // Import Modul
import '../models/bab.dart'; // ✅ IMPORT EXPLICIT BAB
import '../models/quiz_result.dart'; // Import QuizResult
import '../providers/quiz_provider.dart';
import 'detail_materi_screen.dart';
import 'quiz_screen.dart';

class BabListScreen extends StatelessWidget {
  final Modul modul;

  const BabListScreen({super.key, required this.modul});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(modul.nama),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        itemCount: modul.babList.length,
        padding: const EdgeInsets.symmetric(vertical: 16),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final bab = modul.babList[index];
          final quizResult = quizProvider.results[bab.id];

          return _BabCard(
            bab: bab,
            modul: modul,
            index: index,
            quizResult: quizResult,
            onRetakeQuiz: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    babId: bab.id,
                    babNama: bab.judul,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _BabCard extends StatelessWidget {
  final Bab bab;
  final Modul modul;
  final int index;
  final QuizResult? quizResult;
  final VoidCallback onRetakeQuiz;

  const _BabCard({
    required this.bab,
    required this.modul,
    required this.index,
    this.quizResult,
    required this.onRetakeQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final hasQuizResult = quizResult != null;
    final score = hasQuizResult ? quizResult!.score : 0;
    final isPassed = score >= 3;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            title: Text(
              bab.judul,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              'Tap untuk membaca materi',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailMateriScreen(
                    modulId: modul.id,
                    modulNama: modul.nama,
                    babId: bab.id,
                    babNama: bab.judul,
                    isiMateri: bab.konten,
                  ),
                ),
              );
            },
          ),

          // Quiz Result Section
          if (hasQuizResult) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPassed
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPassed ? Icons.check_circle : Icons.quiz,
                          size: 14,
                          color: isPassed
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Quiz: $score/5',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isPassed
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onRetakeQuiz,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text(
                      'Ulangi Quiz',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.quiz, size: 16),
                  label: const Text('Mulai Quiz'),
                  onPressed: onRetakeQuiz,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
