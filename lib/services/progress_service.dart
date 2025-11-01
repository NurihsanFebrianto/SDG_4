import 'dart:convert';
import 'package:aplikasi_materi_kurikulum/models/progress_model.dart';
import 'package:http/http.dart' as http;

class ProgressService {
  static const String url =
      'https://68f3be64fd14a9fcc429b996.mockapi.io/education/progres';

  // Ambil satu progres terakhir (untuk halaman Home)
  static Future<StudyProgress> fetchProgress(String userId) async {
    final response = await http.get(Uri.parse('$url?userId=$userId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        final progressData = data.last;
        return StudyProgress.fromJson(progressData);
      } else {
        throw Exception('Data progres tidak ditemukan untuk userId: $userId');
      }
    } else {
      throw Exception(
          'Gagal memuat data progres (Status: ${response.statusCode})');
    }
  }

  // Ambil semua progres (untuk halaman Lihat Semua)
  static Future<List<StudyProgress>> fetchAllProgress(String userId) async {
    final response = await http.get(Uri.parse('$url?userId=$userId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data
            .map<StudyProgress>((json) => StudyProgress.fromJson(json))
            .toList();
      } else {
        throw Exception('Format data tidak valid');
      }
    } else {
      throw Exception('Gagal memuat semua progres');
    }
  }
}
