import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';
import '../providers/user_provider.dart';
import '../providers/quiz_provider.dart';
import '../models/catatan.dart';
import 'tambah_catatan_screen.dart';
import 'quiz_screen.dart';
import 'quiz_result_screen.dart';
import '../services/reading_time_service.dart';

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
  final ReadingTimeService _readingService = ReadingTimeService();
  final ScrollController _scrollController = ScrollController();
  double _lastScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    // Start reading tracking
    _readingService.startReading(widget.modulId, widget.babId);

    // Load scroll position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialScrollPosition();
    });
  }

  void _loadInitialScrollPosition() {
    final userProvider = context.read<UserProvider>();
    final offset = userProvider.data?.lastScrollOffset;
    if (offset != null && _scrollController.hasClients) {
      _scrollController.jumpTo(offset);
    }
  }

  void _saveScrollPosition() {
    if (_scrollController.hasClients) {
      _lastScrollOffset = _scrollController.offset;
    }
  }

  @override
  void dispose() {
    // Stop reading tracking
    _readingService.stopReading();

    // Save scroll position
    _saveScrollPosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      userProvider.setLastScrollOffset(
        modulId: widget.modulId,
        babId: widget.babId,
        offset: _lastScrollOffset,
      );
    });

    _scrollController.dispose();
    super.dispose();
  }

  void _startNewQuizAttempt(QuizProvider quizProv) {
    // Reset quiz before starting
    quizProv.resetQuiz(widget.babId);

    // Navigate to quiz screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          babId: widget.babId,
          babNama: widget.babNama,
        ),
      ),
    );
  }

  void _showRetakeConfirmationDialog(QuizProvider quizProv) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.refresh_rounded, color: accentOrange),
            const SizedBox(width: 12),
            const Text('Ulangi Quiz?'),
          ],
        ),
        content: const Text(
          'Semua jawaban akan direset dan Anda akan memulai quiz dari awal. Hasil sebelumnya tetap tersimpan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewQuizAttempt(quizProv);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Mulai Ulang'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catProv = context.watch<CatatanProvider>();
    final quizProv = context.watch<QuizProvider>();
    final userProv = context.read<UserProvider>();

    // Set materi terakhir dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProv.setMateriTerakhir(
        modulId: widget.modulId,
        modulNama: widget.modulNama,
        babId: widget.babId,
        babNama: widget.babNama,
      );
    });

    final catatanList = catProv.catatanUntuk(widget.modulId, widget.babId);
    final quizResult = quizProv.results[widget.babId];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.babNama,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              widget.modulNama,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        backgroundColor: primaryDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          if (quizResult != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    successGreen.withOpacity(0.1),
                    secondaryTeal.withOpacity(0.05),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: successGreen.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: successGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: successGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assessment Selesai',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryDarkBlue,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Skor: ${quizResult.score}/5 • ${_getPerformanceText(quizResult.score)}',
                          style: TextStyle(
                            color: neutralGray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: successGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: successGreen.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '${quizResult.score}/5',
                      style: TextStyle(
                        color: successGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.isiMateri,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: primaryDarkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildAcademicNotesSection(catatanList, catProv),
                  const SizedBox(height: 32),
                  _buildAssessmentSection(quizProv),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
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
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(pos);
            }
          },
          backgroundColor: secondaryTeal,
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.note_add_rounded, size: 24),
        ),
      ),
    );
  }

  Widget _buildAcademicNotesSection(
      List<Catatan> catatanList, CatatanProvider catProv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.note_alt_rounded,
                color: primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Catatan Akademik',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryDarkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Catatan pribadi untuk materi ini',
          style: TextStyle(
            color: neutralGray,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        if (catatanList.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.note_outlined,
                  size: 48,
                  color: neutralGray,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Belum Ada Catatan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryDarkBlue,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tambahkan catatan untuk menandai poin penting',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: neutralGray,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: catatanList
                .map((c) => _buildAcademicNoteCard(c, catProv))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildAcademicNoteCard(Catatan c, CatatanProvider catProv) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: secondaryTeal.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _editAcademicNote(context, c);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.isi,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: primaryDarkBlue,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatAcademicDate(c.createdAt),
                        style: TextStyle(
                          color: neutralGray,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _showDeleteNoteDialog(c, catProv);
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: errorRed,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssessmentSection(QuizProvider quizProv) {
    final hasResult = quizProv.results[widget.babId] != null;
    final score = hasResult ? quizProv.results[widget.babId]!.score : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentAmber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.quiz_rounded,
                color: accentAmber,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Assessment Pemahaman',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryDarkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Uji pemahaman Anda dengan soal evaluasi',
          style: TextStyle(
            color: neutralGray,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentAmber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.analytics_rounded,
                        color: accentAmber,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Assessment Komprehensif',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: primaryDarkBlue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '5 soal pilihan ganda • 15 menit',
                            style: TextStyle(
                              color: neutralGray,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (hasResult)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getScoreColor(score).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getScoreColor(score).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hasil Terakhir',
                          style: TextStyle(
                            color: _getScoreColor(score),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$score/5 • ${_getPerformanceText(score)}',
                          style: TextStyle(
                            color: _getScoreColor(score),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (hasResult) {
                        _showRetakeConfirmationDialog(quizProv);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              babId: widget.babId,
                              babNama: widget.babNama,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasResult ? accentOrange : secondaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          hasResult
                              ? Icons.refresh_rounded
                              : Icons.play_arrow_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hasResult ? 'Ulangi Assessment' : 'Mulai Assessment',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (hasResult) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizResultScreen(
                            babId: widget.babId,
                            babNama: widget.babNama,
                            result: quizProv.results[widget.babId]!,
                            questions: quizProv.getQuestions(widget.babId),
                            answers: quizProv
                                .getQuestions(widget.babId)
                                .asMap()
                                .entries
                                .map((entry) =>
                                    quizProv.getAnswer(widget.babId, entry.key))
                                .toList(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Lihat Hasil Sebelumnya',
                      style: TextStyle(
                        color: secondaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _editAcademicNote(BuildContext context, Catatan c) {
    final TextEditingController controller = TextEditingController(text: c.isi);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Edit Catatan Akademik'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Ubah catatan akademik...',
              labelText: 'Catatan',
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
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryTeal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan Perubahan'),
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
        content: const Text(
            'Apakah Anda yakin ingin menghapus catatan akademik ini?'),
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
              backgroundColor: errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String _formatAcademicDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getPerformanceText(int score) {
    if (score >= 4) return 'Excellent';
    if (score >= 3) return 'Good';
    if (score >= 2) return 'Fair';
    return 'Perbaiki lagi';
  }

  Color _getScoreColor(int score) {
    if (score >= 4) return successGreen;
    if (score >= 3) return accentAmber;
    return errorRed;
  }
}
