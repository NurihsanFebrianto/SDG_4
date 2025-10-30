import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../services/database_service.dart';
import '../services/quiz_service.dart';

class QuizProvider with ChangeNotifier {
  final QuizService _quizService = QuizService();

  Map<String, List<QuizQuestion>> _allQuestions = {};
  final Map<String, List<int?>> _answers = {};
  final Map<String, List<bool>> _locked = {};
  final Map<String, QuizResult> _results = {};

  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;
  Map<String, QuizResult> get results => _results;
  bool get hasData => _allQuestions.isNotEmpty;
  List<String> get availableBabIds => _allQuestions.keys.toList();

  QuizProvider() {
    print('🔄 QUIZ PROVIDER INITIALIZED');
    _loadAllQuiz();
    loadResults();
  }

  Future<void> _loadAllQuiz() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print('📡 LOADING QUIZ DATA FROM API...');
      _allQuestions = await _quizService.fetchQuizFromApi();
      _error = '';
      print('✅ QUIZ DATA LOADED: ${_allQuestions.keys.length} bab');
      print('📋 AVAILABLE BAB IDs: ${_allQuestions.keys.join(", ")}');
    } catch (e) {
      print('❌ GAGAL LOAD QUIZ: $e');
      _error = e.toString();
      _allQuestions = _quizService.getDummyQuiz();
      print('🔄 MENGGUNAKAN DATA FALLBACK');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _quizService.clearCache();
    await _loadAllQuiz();
  }

  void loadQuestions(String babId) {
    if (_allQuestions.containsKey(babId)) {
      final questions = _allQuestions[babId]!;
      _answers[babId] = List.filled(questions.length, null);
      _locked[babId] = List.filled(questions.length, false);
      print('✅ QUIZ INITIALIZED FOR: $babId (${questions.length} soal)');
      notifyListeners();
    } else {
      print('⚠️ QUIZ TIDAK DITEMUKAN UNTUK: $babId');
      print('📋 AVAILABLE BAB IDs: ${_allQuestions.keys.join(", ")}');
    }
  }

  List<QuizQuestion> getQuestions(String babId) {
    return _allQuestions[babId] ?? [];
  }

  bool isLocked(String babId, int index) {
    return _locked[babId]?[index] ?? false;
  }

  int? getAnswer(String babId, int index) {
    return _answers[babId]?[index];
  }

  bool hasQuiz(String babId) {
    return _allQuestions.containsKey(babId) && _allQuestions[babId]!.isNotEmpty;
  }

  int getTotalQuestions(String babId) {
    return _allQuestions[babId]?.length ?? 0;
  }

  int getAnsweredCount(String babId) {
    if (_answers[babId] == null) return 0;
    return _answers[babId]!.where((answer) => answer != null).length;
  }

  bool isAllAnswered(String babId) {
    final total = getTotalQuestions(babId);
    final answered = getAnsweredCount(babId);
    return total > 0 && total == answered;
  }

  void selectAnswer(
    BuildContext context,
    String babId,
    int qIndex,
    int selectedIndex,
  ) {
    if (_locked[babId]?[qIndex] == true) {
      print('⚠️ SOAL SUDAH TERKUNCI');
      return;
    }

    final questions = _allQuestions[babId];
    if (questions == null || qIndex >= questions.length) {
      print('⚠️ INDEX SOAL TIDAK VALID');
      return;
    }

    final question = questions[qIndex];

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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<QuizResult> submitQuiz(String babId) async {
    final questions = _allQuestions[babId] ?? [];
    final answers = _answers[babId] ?? [];

    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (i < answers.length && answers[i] == questions[i].correctIndex) {
        correctCount++;
      }
    }

    final result = QuizResult(
      babId: babId,
      score: correctCount,
      totalQuestions: questions.length,
    );

    _results[babId] = result;

    try {
      await DatabaseService.instance.saveQuizResult(result);
      print('✅ QUIZ RESULT SAVED TO DATABASE');
    } catch (e) {
      print('❌ ERROR SAVING QUIZ RESULT: $e');
    }

    notifyListeners();

    print(
        '📊 QUIZ SUBMITTED: ${result.score}/${result.totalQuestions} (${result.percentage.toStringAsFixed(1)}%)');

    return result;
  }

  Future<void> loadResults() async {
    try {
      final savedResults = await DatabaseService.instance.getQuizResults();
      _results
        ..clear()
        ..addAll(savedResults);
      print('✅ LOADED ${_results.length} SAVED QUIZ RESULTS');
      notifyListeners();
    } catch (e) {
      print('❌ ERROR LOADING QUIZ RESULTS: $e');
    }
  }

  QuizResult? getResult(String babId) {
    return _results[babId];
  }

  void resetQuiz(String babId) {
    if (_allQuestions[babId] == null) {
      print('⚠️ CANNOT RESET: Quiz tidak ditemukan untuk $babId');
      return;
    }

    _answers[babId] = List.filled(_allQuestions[babId]!.length, null);
    _locked[babId] = List.filled(_allQuestions[babId]!.length, false);

    print('🔄 QUIZ RESET FOR: $babId');
    notifyListeners();
  }

  void resetAll() {
    _answers.clear();
    _locked.clear();
    print('🔄 ALL QUIZ RESET');
    notifyListeners();
  }

  @override
  void dispose() {
    _answers.clear();
    _locked.clear();
    _results.clear();
    _allQuestions.clear();
    super.dispose();
  }
}
