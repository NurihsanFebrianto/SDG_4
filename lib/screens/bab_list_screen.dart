import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/modul.dart';
import '../models/bab.dart';
import '../providers/quiz_provider.dart';
import 'detail_materi_screen.dart';
import 'quiz_screen.dart';

class BabListScreen extends StatelessWidget {
  final Modul modul;
  const BabListScreen({super.key, required this.modul});

  @override
  Widget build(BuildContext context) {
    // Pastikan provider sudah diinisialisasi agar hasil quiz bisa dimuat
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.loadResults();

    return Scaffold(
      appBar: AppBar(title: Text(modul.nama)),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, _) {
          return ListView.separated(
            itemCount: modul.babList.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final Bab bab = modul.babList[index];
              final result = quizProvider.results[bab.id];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    bab.judul,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nilai Quiz kalau sudah pernah dikerjakan
                      if (result != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Nilai terakhir: ${result.score}/5',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 13,
                            ),
                          ),
                        ),

                      // Tombol Latihan Soal
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.quiz, size: 18),
                          label: const Text('Latihan Soal'),
                          onPressed: () {
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
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.menu_book),
                    tooltip: 'Baca Materi',
                    onPressed: () {
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
