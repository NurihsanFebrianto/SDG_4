import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';

class QuizService {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/kingrandu/dummy-bank-quiz/main/soal.json';

  static Map<String, List<QuizQuestion>>? _cachedQuestions;

  Future<Map<String, List<QuizQuestion>>> fetchQuizFromApi() async {
    if (_cachedQuestions != null) {
      print('📦 USING CACHED QUIZ DATA');
      return _cachedQuestions!;
    }

    try {
      print('🚀 FETCHING QUIZ DATA FROM: $_baseUrl');

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 STATUS CODE: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonRoot = json.decode(response.body);
        final Map<String, dynamic> quizData =
            jsonRoot['quizQuestions'] as Map<String, dynamic>;

        print('✅ QUIZ DATA DITERIMA, JUMLAH BAB: ${quizData.keys.length}');

        final Map<String, List<QuizQuestion>> result = {};

        quizData.forEach((babId, questions) {
          final List<dynamic> questionList = questions as List;
          result[babId] = questionList
              .map((q) => QuizQuestion.fromMap(q as Map<String, dynamic>))
              .toList();

          print('📋 BAB $babId: ${result[babId]!.length} soal');
        });

        _cachedQuestions = result;

        return result;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ERROR FETCH QUIZ: $e');
      rethrow;
    }
  }

  Map<String, List<QuizQuestion>> getDummyQuiz() {
    return {
      'fallback': [
        QuizQuestion(
          question:
              'Data quiz tidak dapat dimuat. Periksa koneksi internet Anda.',
          options: ['OK', 'Coba Lagi', 'Batal', 'Tutup'],
          correctIndex: 0,
          explanation:
              'Silakan refresh halaman atau periksa koneksi internet Anda.',
        ),
      ],
    };
  }

  void clearCache() {
    _cachedQuestions = null;
    print('🗑️ QUIZ CACHE CLEARED');
  }

  bool get isCached => _cachedQuestions != null;

  Map<String, List<QuizQuestion>>? get cachedData => _cachedQuestions;
}
