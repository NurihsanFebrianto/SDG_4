import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz_question.dart';

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

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<QuizProvider>(context, listen: false)
          .loadQuestions(widget.babId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProv = Provider.of<QuizProvider>(context);
    final questions = quizProv.getQuestions(widget.babId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Latihan: ${widget.babNama}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Mulai ulang kuis',
            onPressed: () {
              quizProv.resetQuiz(widget.babId);
            },
          ),
        ],
      ),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final selected = quizProv.getAnswer(widget.babId, index);
                final locked = quizProv.isLocked(widget.babId, index);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soal ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          question.question,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(question.options.length, (optIndex) {
                          final optionText = question.options[optIndex];
                          final isSelected = selected == optIndex;
                          final isCorrect =
                              question.correctIndex == optIndex && locked;
                          final isWrong =
                              isSelected && selected != question.correctIndex;

                          Color getColor() {
                            if (!locked) return Colors.grey.shade200;
                            if (isCorrect) return Colors.green.shade100;
                            if (isWrong) return Colors.red.shade100;
                            return Colors.grey.shade200;
                          }

                          return GestureDetector(
                            onTap: locked
                                ? null
                                : () {
                                    quizProv.selectAnswer(
                                        context, widget.babId, index, optIndex);
                                  },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: getColor(),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.indigo
                                      : Colors.grey.shade300,
                                  width: 1.5,
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
                                  Expanded(
                                    child: Text(optionText),
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
      floatingActionButton: questions.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                quizProv.submitQuiz(context, widget.babId);
              },
              icon: const Icon(Icons.check),
              label: const Text('Submit Jawaban'),
              backgroundColor: Colors.indigo,
            ),
    );
  }
}
