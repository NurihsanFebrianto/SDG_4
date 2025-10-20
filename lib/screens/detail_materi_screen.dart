import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';
import '../providers/user_provider.dart';
import '../providers/quiz_provider.dart';
import '../models/catatan.dart';
import 'tambah_catatan_screen.dart';
import 'quiz_screen.dart';

class DetailMateriScreen extends StatefulWidget {
  final String modulId;
  final String modulNama;
  final String babId;
  final String babNama;
  final String isiMateri;

  const DetailMateriScreen({
    super.key,
    required this.modulId,
    required this.modulNama,
    required this.babId,
    required this.babNama,
    required this.isiMateri,
  });

  @override
  State<DetailMateriScreen> createState() => _DetailMateriScreenState();
}

class _DetailMateriScreenState extends State<DetailMateriScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Simpan materi terakhir dibuka
    final userProv = context.read<UserProvider>();
    userProv.setMateriTerakhir(
      modulId: widget.modulId,
      modulNama: widget.modulNama,
      babId: widget.babId,
      babNama: widget.babNama,
    );

    // Restore scroll offset kalau ada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final offset = userProv.data?.lastScrollOffset;
      if (offset != null) {
        _scrollController.jumpTo(offset);
      }
    });
  }

  @override
  void dispose() {
    // Simpan posisi scroll terakhir
    final userProv = context.read<UserProvider>();
    userProv.setLastScrollOffset(
      modulId: widget.modulId,
      babId: widget.babId,
      offset: _scrollController.offset,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catProv = context.watch<CatatanProvider>();
    final quizProv = context.watch<QuizProvider>();
    final catatanList = catProv.catatanUntuk(widget.modulId, widget.babId);
    final quizResult = quizProv.results[widget.babId];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.babNama),
        actions: [
          // Tombol Quiz
          IconButton(
            icon: const Icon(Icons.quiz),
            tooltip: 'Mulai Quiz',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    babId: widget.babId,
                    babNama: widget.babNama,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header dengan info quiz
          if (quizResult != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Skor Quiz: ${quizResult.score}/5',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            babId: widget.babId,
                            babNama: widget.babNama,
                          ),
                        ),
                      );
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),

          // Konten materi
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isiMateri,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 32),

                  // Section Side Notes
                  _buildSideNotesSection(catatanList, catProv),

                  const SizedBox(height: 32),

                  // Section Quiz
                  _buildQuizSection(quizProv),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pos = _scrollController.offset;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TambahCatatanScreen(
                modulId: widget.modulId,
                modulNama: widget.modulNama,
                babId: widget.babId,
                babNama: widget.babNama,
              ),
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(pos);
          });
        },
        child: const Icon(Icons.note_add),
      ),
    );
  }

  Widget _buildSideNotesSection(
      List<Catatan> catatanList, CatatanProvider catProv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Side Notes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (catatanList.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Belum ada side note untuk bab ini. Tap + untuk menambahkan.',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          )
        else
          Column(
            children:
                catatanList.map((c) => _buildNoteCard(c, catProv)).toList(),
          ),
      ],
    );
  }

  Widget _buildNoteCard(Catatan c, CatatanProvider catProv) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(c.isi),
        subtitle: Text(
          'Dibuat: ${_formatDate(c.createdAt)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          onPressed: () {
            _showDeleteNoteDialog(c, catProv);
          },
        ),
        onTap: () {
          _editSideNote(context, c);
        },
      ),
    );
  }

  Widget _buildQuizSection(QuizProvider quizProv) {
    final hasResult = quizProv.results[widget.babId] != null;
    final score = hasResult ? quizProv.results[widget.babId]!.score : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz Bab Ini',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.quiz,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tes pemahaman Anda',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '5 soal pilihan ganda',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (hasResult)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: score >= 3
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Skor Terakhir: $score/5',
                      style: TextStyle(
                        color: score >= 3
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: Text(hasResult ? 'Coba Lagi' : 'Mulai Quiz'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            babId: widget.babId,
                            babNama: widget.babNama,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _editSideNote(BuildContext context, Catatan c) {
    final TextEditingController controller = TextEditingController(text: c.isi);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Edit Catatan'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Ubah catatan...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final isiBaru = controller.text.trim();
                if (isiBaru.isNotEmpty) {
                  Provider.of<CatatanProvider>(context, listen: false)
                      .updateCatatan(c.id, isiBaru);
                }
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteNoteDialog(Catatan c, CatatanProvider catProv) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              catProv.hapusCatatan(c.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
