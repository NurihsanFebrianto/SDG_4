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

  // Map untuk menyimpan attempt baru yang belum di-submit
  final Map<String, List<int?>> _pendingAttempts = {};
  final Map<String, List<bool>> _pendingLocks = {};

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

    // Jangan reset jika sudah ada attempt yang sedang berjalan
    if (_pendingAttempts.containsKey(babId)) return;

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
    // Prioritaskan pending attempt, lalu yang aktif
    return _pendingLocks[babId]?[index] ?? _locked[babId]?[index] ?? false;
  }

  int? getAnswer(String babId, int index) {
    // Prioritaskan pending attempt, lalu yang aktif
    return _pendingAttempts[babId]?[index] ?? _answers[babId]?[index];
  }

  bool hasQuiz(String babId) {
    return _allQuestions.containsKey(babId) && _allQuestions[babId]!.isNotEmpty;
  }

  int getTotalQuestions(String babId) {
    return _allQuestions[babId]?.length ?? 0;
  }

  int getAnsweredCount(String babId) {
    // Hitung dari pending attempt dulu, lalu yang aktif
    final pendingAnswers = _pendingAttempts[babId];
    if (pendingAnswers != null) {
      return pendingAnswers.where((e) => e != null).length;
    }
    return _answers[babId]?.where((e) => e != null).length ?? 0;
  }

  bool isAllAnswered(String babId) {
    final total = getTotalQuestions(babId);
    final answered = getAnsweredCount(babId);
    return total > 0 && total == answered;
  }

  /// ✅ Logic jawaban - gunakan pending attempt jika ada
  bool selectAnswer(String babId, int qIndex, int selectedIndex) {
    // Gunakan pending attempt jika sedang retake
    if (_pendingAttempts.containsKey(babId)) {
      if (_pendingLocks[babId]?[qIndex] == true) return false;

      _pendingAttempts[babId]![qIndex] = selectedIndex;
      _pendingLocks[babId]![qIndex] = true;

      notifyListeners();

      final question = _allQuestions[babId]![qIndex];
      return selectedIndex == question.correctIndex;
    }
    // Normal flow
    else {
      if (_locked[babId]?[qIndex] == true) return false;

      _answers[babId]![qIndex] = selectedIndex;
      _locked[babId]![qIndex] = true;

      notifyListeners();

      final question = _allQuestions[babId]![qIndex];
      return selectedIndex == question.correctIndex;
    }
  }

  /// ✅ BUAT METHOD UNTUK MEMULAI ATTEMPT BARU
  void startNewAttempt(String babId) {
    if (!_allQuestions.containsKey(babId)) return;

    final len = _allQuestions[babId]!.length;

    // RESET STATE JAWABAN YANG AKTIF
    _answers[babId] = List<int?>.filled(len, null);
    _locked[babId] = List<bool>.filled(len, false);

    // Juga reset pending attempts jika ada
    _pendingAttempts.remove(babId);
    _pendingLocks.remove(babId);

    debugPrint('🔄 NEW ATTEMPT STARTED: $babId (state reset)');
    notifyListeners();
  }

  /// ✅ SUBMIT QUIZ - handle both normal dan pending attempts
  Future<QuizResult> submitQuiz(String babId) async {
    final questions = getQuestions(babId);

    // Gunakan pending attempt jika ada, else gunakan yang normal
    final answers = _pendingAttempts.containsKey(babId)
        ? _pendingAttempts[babId]!
        : _answers[babId] ?? [];

    int correctCount = 0;
    for (var i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].correctIndex) correctCount++;
    }

    final result = QuizResult(
      babId: babId,
      score: correctCount,
      totalQuestions: questions.length,
    );

    // ✅ HASIL LAMA DI-REPLACE HANYA SETELAH SUBMIT BERHASIL
    _results[babId] = result;

    // Jika ini adalah pending attempt, pindahkan ke state normal
    if (_pendingAttempts.containsKey(babId)) {
      _answers[babId] = List.from(_pendingAttempts[babId]!);
      _locked[babId] = List.from(_pendingLocks[babId]!);
      _pendingAttempts.remove(babId);
      _pendingLocks.remove(babId);
    }

    try {
      await DatabaseService.instance.saveQuizResult(result);
      debugPrint('✅ QUIZ RESULT SAVED TO DB');
    } catch (e) {
      debugPrint('❌ ERROR SAVE DB: $e');
    }

    notifyListeners();
    return result;
  }

  /// ✅ RESET QUIZ - reset semua state jawaban
  void resetQuiz(String babId) {
    if (!_allQuestions.containsKey(babId)) return;

    final len = _allQuestions[babId]!.length;

    // Reset semua state jawaban
    _answers[babId] = List<int?>.filled(len, null);
    _locked[babId] = List<bool>.filled(len, false);
    _pendingAttempts.remove(babId);
    _pendingLocks.remove(babId);

    // JANGAN hapus results di sini - biarkan hasil lama tetap tersimpan
    // _results.remove(babId); // ← JANGAN lakukan ini

    debugPrint('🔄 QUIZ RESET: $babId (all answer state cleared)');
    notifyListeners();
  }

  /// ✅ CEK APAKAH SEDANG DALAM ATTEMPT BARU
  bool isInNewAttempt(String babId) {
    return _pendingAttempts.containsKey(babId);
  }

  /// ✅ BATALKAN ATTEMPT BARU DAN KEMBALI KE STATE SEBELUMNYA
  void cancelNewAttempt(String babId) {
    _pendingAttempts.remove(babId);
    _pendingLocks.remove(babId);
    debugPrint('❌ NEW ATTEMPT CANCELLED: $babId');
    notifyListeners();
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

  void resetAll() {
    _answers.clear();
    _locked.clear();
    _pendingAttempts.clear();
    _pendingLocks.clear();
    _results.clear();
    debugPrint('🔄 RESET ALL QUIZ');
    notifyListeners();
  }
}
