import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bab.dart';
import '../models/modul.dart';

class ModulService {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/kingrandu/dummy-bank-quiz/main/materi.json';

  Future<List<Modul>> fetchModulFromApi() async {
    try {
      print('🚀 FETCHING DATA FROM: $_baseUrl');

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 STATUS CODE: ${response.statusCode}');

      if (response.statusCode == 200) {
        // PERBAIKAN UTAMA: Parse root object dulu
        final Map<String, dynamic> jsonRoot = json.decode(response.body);

        // Ambil array dari key "semuaModulDummy"
        final List<dynamic> jsonData = jsonRoot['semuaModulDummy'] as List;

        print('✅ DATA DITERIMA, JUMLAH MODUL: ${jsonData.length}');

        if (jsonData.isNotEmpty) {
          print('📋 CONTOH DATA PERTAMA: ${jsonData.first['nama']}');
        }

        return jsonData.map((modulJson) => Modul.fromMap(modulJson)).toList();
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ERROR FETCH: $e');
      rethrow; // Lempar ulang error untuk ditangkap Provider
    }
  }

  List<Modul> getDummyModul() {
    return [
      Modul(
        id: 'fallback-1',
        nama: 'DATA FALLBACK - GAGAL FETCH',
        babList: [
          Bab(
            id: 'fb1',
            judul: 'Bab Fallback',
            konten: 'Periksa koneksi internet Anda dan coba lagi.',
          ),
        ],
      ),
    ];
  }
}
