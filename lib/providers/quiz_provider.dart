import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../services/database_service.dart';
import '../screens/quiz_result_screen.dart';

class QuizProvider extends ChangeNotifier {
  final Map<String, List<QuizQuestion>> _questions = {};
  final Map<String, List<int?>> _answers = {};
  final Map<String, List<bool>> _locked = {};
  final Map<String, QuizResult> _results = {};

  Map<String, QuizResult> get results => _results;

  void loadQuestions(String babId) {
    _questions[babId] = QuizBank.getQuestions(babId);
    _answers[babId] = List.filled(_questions[babId]!.length, null);
    _locked[babId] = List.filled(_questions[babId]!.length, false);
    notifyListeners();
  }

  List<QuizQuestion> getQuestions(String babId) => _questions[babId] ?? [];
  bool isLocked(String babId, int index) => _locked[babId]?[index] ?? false;
  int? getAnswer(String babId, int index) => _answers[babId]?[index];

  void selectAnswer(
      BuildContext context, String babId, int qIndex, int selectedIndex) {
    if (_locked[babId]?[qIndex] == true) return;
    final question = _questions[babId]![qIndex];
    _answers[babId]![qIndex] = selectedIndex;
    _locked[babId]![qIndex] = true;
    notifyListeners();

    final bool isCorrect = selectedIndex == question.correctIndex;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        content: Text(
          isCorrect
              ? '✅ Benar! ${question.explanation}'
              : '❌ Salah! ${question.explanation}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> submitQuiz(BuildContext context, String babId) async {
    final questions = _questions[babId] ?? [];
    final answers = _answers[babId] ?? [];

    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].correctIndex) correctCount++;
    }

    final result = QuizResult(babId: babId, score: correctCount);
    _results[babId] = result;

    await DatabaseService.instance.saveQuizResult(result);
    notifyListeners();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          babId: babId,
          result: result,
          questions: questions,
          answers: answers,
        ),
      ),
    );
  }

  void resetQuiz(String babId) {
    if (_questions[babId] == null) return;
    _answers[babId] = List.filled(_questions[babId]!.length, null);
    _locked[babId] = List.filled(_questions[babId]!.length, false);
    notifyListeners();
  }

  Future<void> loadResults() async {
    final savedResults = await DatabaseService.instance.getQuizResults();
    _results
      ..clear()
      ..addAll(savedResults);
    notifyListeners();
  }
}
