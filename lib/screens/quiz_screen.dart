import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz_question.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String babId;
  final String babNama;

  const QuizScreen({
    super.key,
    required this.babId,
    required this.babNama,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _progressController;
  Animation<double>? _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController!, curve: Curves.easeInOut),
    );

    Future.microtask(() {
      Provider.of<QuizProvider>(context, listen: false)
          .loadQuestions(widget.babId);
    });
  }

  @override
  void dispose() {
    _progressController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProv = Provider.of<QuizProvider>(context);
    final questions = quizProv.getQuestions(widget.babId);
    final answeredCount = _countAnswered(quizProv, widget.babId);
    final totalCount = questions.length;
    final progressPercent = totalCount > 0 ? answeredCount / totalCount : 0.0;

    // Update progress animation
    if (_progressController != null) {
      _progressController!.animateTo(progressPercent);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              widget.babNama,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Mulai Ulang',
            onPressed: () {
              _showResetDialog(context, quizProv);
            },
          ),
        ],
      ),
      body: questions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Memuat soal quiz...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Premium Progress Header
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade400,
                                    Colors.blue.shade600
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.assignment_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Progress Quiz',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '$answeredCount',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        ' / $totalCount',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'soal',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (answeredCount == totalCount)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      'Selesai',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Animated Progress Bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _progressAnimation != null
                                  ? AnimatedBuilder(
                                      animation: _progressAnimation!,
                                      builder: (context, child) {
                                        return LinearProgressIndicator(
                                          value: _progressAnimation!.value,
                                          minHeight: 8,
                                          backgroundColor: Colors.grey[200],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            _progressAnimation!.value == 1.0
                                                ? Colors.green
                                                : Colors.blue,
                                          ),
                                        );
                                      },
                                    )
                                  : LinearProgressIndicator(
                                      value: progressPercent,
                                      minHeight: 8,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        progressPercent == 1.0
                                            ? Colors.green
                                            : Colors.blue,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(progressPercent * 100).toStringAsFixed(0)}% Selesai',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${totalCount - answeredCount} tersisa',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Questions List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final selected = quizProv.getAnswer(widget.babId, index);
                      final locked = quizProv.isLocked(widget.babId, index);
                      final isAnswered = selected != null;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isAnswered
                                ? Colors.blue.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question Header
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isAnswered
                                            ? [
                                                Colors.blue.shade400,
                                                Colors.blue.shade600
                                              ]
                                            : [
                                                Colors.grey.shade300,
                                                Colors.grey.shade400
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Soal ${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        if (isAnswered)
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 14,
                                                color: Colors.green[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Terjawab',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.green[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Question Text
                              Text(
                                question.question,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Divider
                              Container(
                                height: 1,
                                color: Colors.grey[200],
                              ),
                              const SizedBox(height: 16),

                              // Options
                              ...List.generate(question.options.length,
                                  (optIndex) {
                                final optionText = question.options[optIndex];
                                final isSelected = selected == optIndex;
                                final isCorrect =
                                    question.correctIndex == optIndex && locked;
                                final isWrong = isSelected &&
                                    selected != question.correctIndex &&
                                    locked;

                                Color getBgColor() {
                                  if (!locked) {
                                    return isSelected
                                        ? Colors.blue.shade50
                                        : Colors.grey.shade50;
                                  }
                                  if (isCorrect) return Colors.green.shade50;
                                  if (isWrong) return Colors.red.shade50;
                                  return Colors.grey.shade50;
                                }

                                Color getBorderColor() {
                                  if (!locked) {
                                    return isSelected
                                        ? Colors.blue.shade300
                                        : Colors.grey.shade200;
                                  }
                                  if (isCorrect) return Colors.green.shade300;
                                  if (isWrong) return Colors.red.shade300;
                                  return Colors.grey.shade200;
                                }

                                return GestureDetector(
                                  onTap: locked
                                      ? null
                                      : () {
                                          quizProv.selectAnswer(
                                            context,
                                            widget.babId,
                                            index,
                                            optIndex,
                                          );
                                        },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: getBgColor(),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: getBorderColor(),
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Option Letter Circle
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? (locked
                                                    ? (isCorrect
                                                        ? Colors.green
                                                        : Colors.red)
                                                    : Colors.blue)
                                                : (isCorrect
                                                    ? Colors.green
                                                    : Colors.grey.shade300),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              String.fromCharCode(
                                                  65 + optIndex),
                                              style: TextStyle(
                                                color: isSelected || isCorrect
                                                    ? Colors.white
                                                    : Colors.grey.shade700,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Option Text
                                        Expanded(
                                          child: Text(
                                            optionText,
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.4,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),

                                        // Check/Cross Icon
                                        if (locked && isCorrect)
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        if (locked && isWrong)
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: questions.isEmpty || answeredCount < totalCount
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _submitQuiz(context, quizProv),
              icon: const Icon(Icons.send_rounded),
              label: const Text(
                'Submit Jawaban',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.green,
              elevation: 4,
            ),
    );
  }

  int _countAnswered(QuizProvider provider, String babId) {
    final answers = provider
        .getQuestions(babId)
        .asMap()
        .entries
        .map((entry) {
          return provider.getAnswer(babId, entry.key);
        })
        .where((answer) => answer != null)
        .length;

    return answers;
  }

  void _showResetDialog(BuildContext context, QuizProvider quizProv) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.refresh_rounded, color: Colors.orange[700]),
            const SizedBox(width: 12),
            const Text('Mulai Ulang Quiz?'),
          ],
        ),
        content: const Text(
          'Semua jawaban akan dihapus dan kamu harus mengerjakan quiz dari awal lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              quizProv.resetQuiz(widget.babId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quiz telah direset'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitQuiz(BuildContext context, QuizProvider quizProv) async {
    final questions = quizProv.getQuestions(widget.babId);
    final answers = questions.asMap().entries.map((entry) {
      return quizProv.getAnswer(widget.babId, entry.key);
    }).toList();

    // Submit quiz dan dapatkan result
    final result = await quizProv.submitQuiz(widget.babId);

    // Navigate ke result screen dan tunggu response
    final shouldRetake = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          babId: widget.babId,
          babNama: widget.babNama,
          result: result,
          questions: questions,
          answers: answers,
        ),
      ),
    );

    // Handle retake jika user kembali dengan flag 'retake'
    if (shouldRetake == 'retake' && mounted) {
      quizProv.resetQuiz(widget.babId);
      // Reload screen dengan state baru
      setState(() {});
    }
  }
}
