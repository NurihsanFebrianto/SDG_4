import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../services/database_service.dart';
import '../services/quiz_service.dart';

class QuizProvider with ChangeNotifier {
  final QuizService _quizService = QuizService();

  final Map<String, List<QuizQuestion>> _allQuestions = {};
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
    debugPrint('🔄 QUIZ PROVIDER INITIALIZED');
    _loadAllQuiz();
    loadResults();
  }

  Future<void> _loadAllQuiz() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      debugPrint('📡 LOADING QUIZ DATA FROM API...');
      final fetched = await _quizService.fetchQuizFromApi();

      if (fetched.isNotEmpty) {
        _allQuestions
          ..clear()
          ..addAll(fetched);
        debugPrint('✅ QUIZ DATA LOADED: ${_allQuestions.length} bab');
      } else {
        throw Exception("API returned empty data");
      }
    } catch (e) {
      debugPrint('❌ GAGAL LOAD QUIZ: $e');
      _error = e.toString();
      _allQuestions
        ..clear()
        ..addAll(_quizService.getDummyQuiz());
      debugPrint('🔄 USING FALLBACK DATA');
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
    if (!_allQuestions.containsKey(babId)) {
      debugPrint('⚠️ QUIZ NOT FOUND FOR: $babId');
      return;
    }

    if (_answers.containsKey(babId))
      return; // Jangan reset ulang tanpa resetQuiz

    final questions = _allQuestions[babId]!;
    _answers[babId] = List<int?>.filled(questions.length, null);
    _locked[babId] = List<bool>.filled(questions.length, false);

    debugPrint('✅ QUIZ INIT: $babId (${questions.length} soal)');
    notifyListeners();
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
    return _answers[babId]?.where((e) => e != null).length ?? 0;
  }

  bool isAllAnswered(String babId) {
    final total = getTotalQuestions(babId);
    final answered = getAnsweredCount(babId);
    return total > 0 && total == answered;
  }

  /// ✅ Logic jawaban ada di provider (UI hanya panggil)
  /// return true = benar, false = salah
  bool selectAnswer(String babId, int qIndex, int selectedIndex) {
    if (_locked[babId]?[qIndex] == true) return false;

    _answers[babId]![qIndex] = selectedIndex;
    _locked[babId]![qIndex] = true;

    notifyListeners();

    final question = _allQuestions[babId]![qIndex];
    return selectedIndex == question.correctIndex;
  }

  Future<QuizResult> submitQuiz(String babId) async {
    final questions = getQuestions(babId);
    final answers = _answers[babId] ?? [];

    int correctCount = 0;
    for (var i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].correctIndex) correctCount++;
    }

    final result = QuizResult(
      babId: babId,
      score: correctCount,
      totalQuestions: questions.length,
    );

    _results[babId] = result;

    try {
      await DatabaseService.instance.saveQuizResult(result);
      debugPrint('✅ QUIZ RESULT SAVED TO DB');
    } catch (e) {
      debugPrint('❌ ERROR SAVE DB: $e');
    }

    notifyListeners();
    return result;
  }

  Future<void> loadResults() async {
    try {
      final saved = await DatabaseService.instance.getQuizResults();
      _results
        ..clear()
        ..addAll(saved);
      debugPrint('✅ LOADED ${_results.length} SAVED RESULTS');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ ERROR LOAD RESULTS: $e');
    }
  }

  QuizResult? getResult(String babId) => _results[babId];

  void resetQuiz(String babId) {
    if (!_allQuestions.containsKey(babId)) return;

    final len = _allQuestions[babId]!.length;
    _answers[babId] = List<int?>.filled(len, null);
    _locked[babId] = List<bool>.filled(len, false);
    _results.remove(babId);

    debugPrint('🔄 RESET QUIZ: $babId');
    notifyListeners();
  }

  void resetAll() {
    _answers.clear();
    _locked.clear();
    _results.clear();
    debugPrint('🔄 RESET ALL QUIZ');
    notifyListeners();
  }
}
