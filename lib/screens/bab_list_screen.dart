import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/modul.dart';
import '../models/bab.dart';
import '../models/quiz_result.dart';
import '../providers/quiz_provider.dart';
import '../services/reading_time_service.dart';
import 'detail_materi_screen.dart';
import 'quiz_result_screen.dart';

// Academic Color Scheme
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

class BabListScreen extends StatelessWidget {
  final Modul modul;

  const BabListScreen({super.key, required this.modul});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final completedCount = _countCompletedQuiz(quizProvider);
    final totalCount = modul.babList.length;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Struktur Pembelajaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              modul.nama,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: primaryDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Academic Header Stats
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryDarkBlue, primaryBlue],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryDarkBlue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            modul.nama,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$totalCount Bab Akademik Tersedia',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress Belajar',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$completedCount dari $totalCount bab selesai',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: totalCount > 0 ? completedCount / totalCount : 0,
                        backgroundColor: Colors.grey.shade200,
                        color: secondaryTeal,
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${totalCount > 0 ? ((completedCount / totalCount) * 100).toStringAsFixed(0) : 0}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryDarkBlue,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Progress Penyelesaian Modul',
                    style: TextStyle(
                      color: neutralGray,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bab List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: modul.babList.length,
              itemBuilder: (context, index) {
                final bab = modul.babList[index];
                final quizResult = quizProvider.results[bab.id];

                return _AcademicBabCard(
                  key: ValueKey(bab.id),
                  bab: bab,
                  modul: modul,
                  index: index,
                  quizResult: quizResult,
                  quizProvider: quizProvider,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _countCompletedQuiz(QuizProvider provider) {
    return modul.babList
        .where((bab) => provider.results[bab.id] != null)
        .length;
  }
}

class _AcademicBabCard extends StatefulWidget {
  final Bab bab;
  final Modul modul;
  final int index;
  final QuizResult? quizResult;
  final QuizProvider quizProvider;

  const _AcademicBabCard({
    super.key,
    required this.bab,
    required this.modul,
    required this.index,
    this.quizResult,
    required this.quizProvider,
  });

  @override
  State<_AcademicBabCard> createState() => _AcademicBabCardState();
}

class _AcademicBabCardState extends State<_AcademicBabCard> {
  final ReadingTimeService _readingService = ReadingTimeService();
  double _readingProgress = 0.0;
  int _readingTimeSeconds = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await _readingService.getProgressPercent(widget.bab.id);
    final seconds = await _readingService.getReadingTime(widget.bab.id);

    if (mounted) {
      setState(() {
        _readingProgress = progress;
        _readingTimeSeconds = seconds;
        _isLoading = false;
      });
    }
  }

  double _calculatePercent() {
    if (widget.quizResult == null) return 0.0;
    final total = widget.quizResult!.totalQuestions;
    if (total == 0) return 0.0;
    return (widget.quizResult!.score / total) * 100.0;
  }

  Color _getStatusColor(double percent) {
    if (percent >= 80) return successGreen;
    if (percent >= 60) return secondaryTeal;
    if (percent >= 50) return accentOrange;
    return errorRed;
  }

  String _getStatusText(double percent) {
    if (percent >= 80) return 'Excellent';
    if (percent >= 60) return 'Good';
    if (percent >= 50) return 'Fair';
    return 'Need Practice';
  }

  IconData _getStatusIcon(double percent) {
    if (percent >= 80) return Icons.emoji_events_rounded;
    if (percent >= 60) return Icons.check_circle_rounded;
    if (percent >= 50) return Icons.warning_amber_rounded;
    return Icons.autorenew_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final hasQuizResult = widget.quizResult != null;
    final percent = _calculatePercent();
    final statusColor = _getStatusColor(percent);
    final statusText = _getStatusText(percent);
    final statusIcon = _getStatusIcon(percent);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        border: Border.all(
          color: hasQuizResult
              ? statusColor.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Main Content - Tap to view materi
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailMateriScreen(
                      modulId: widget.modul.id,
                      modulNama: widget.modul.nama,
                      babId: widget.bab.id,
                      babNama: widget.bab.judul,
                      isiMateri: widget.bab.konten,
                    ),
                  ),
                );
                // Reload progress after returning
                _loadProgress();
              },
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Academic Number Badge
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: hasQuizResult
                              ? [statusColor, statusColor.withOpacity(0.8)]
                              : [primaryBlue, primaryLightBlue],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: (hasQuizResult ? statusColor : primaryBlue)
                                .withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${widget.index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Title & Academic Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bab.judul,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: primaryDarkBlue,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.description_rounded,
                                      size: 14,
                                      color: primaryBlue,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Baca Materi',
                                      style: TextStyle(
                                        color: primaryBlue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (hasQuizResult)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: statusColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        statusIcon,
                                        size: 14,
                                        color: statusColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          statusText,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Academic Arrow Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: primaryBlue,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Reading Progress Bar
          if (!_isLoading && _readingProgress > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: secondaryTeal.withOpacity(0.05),
                border: Border(
                  top: BorderSide(
                    color: secondaryTeal.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: secondaryTeal,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Waktu Baca: ${_readingService.formatTime(_readingTimeSeconds)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: neutralGray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${_readingProgress.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTeal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _readingProgress / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: secondaryTeal,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                ],
              ),
            ),

          // Quiz Section
          if (hasQuizResult)
            Container(
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.03),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(
                  top: BorderSide(
                    color: statusColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    final questions =
                        widget.quizProvider.getQuestions(widget.bab.id);
                    final answers = questions.asMap().entries.map((entry) {
                      return widget.quizProvider
                          .getAnswer(widget.bab.id, entry.key);
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizResultScreen(
                          babId: widget.bab.id,
                          babNama: widget.bab.judul,
                          result: widget.quizResult!,
                          questions: questions,
                          answers: answers,
                        ),
                      ),
                    );
                  },
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Academic Score Circle
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: statusColor,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${percent.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Academic Score Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hasil Assessment',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: neutralGray,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${widget.quizResult!.score}/${widget.quizResult!.totalQuestions} Jawaban Benar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap untuk analisis detail',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: neutralGray,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.analytics_rounded,
                            color: statusColor,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
