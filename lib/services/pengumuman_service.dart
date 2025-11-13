import 'dart:async';
import 'dart:convert';
import 'package:aplikasi_materi_kurikulum/models/pengumuman_model.dart';
import 'package:http/http.dart' as http;

class PengumumanService {
  static const String apiUrl =
      "https://69101da245e65ab24ac5a264.mockapi.io/pengumuman";

  static Future<List<Pengumuman>> getPengumuman() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Pengumuman.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data pengumuman");
    }
  }

  /// 🔁 Stream versi realtime (polling tiap 5 detik)
  static Stream<List<Pengumuman>> streamPengumuman() async* {
    while (true) {
      try {
        final data = await getPengumuman();
        yield data;
      } catch (e) {
        // kalau error, kirim stream kosong agar tidak crash
        yield [];
      }
      await Future.delayed(const Duration(seconds: 5)); // interval refresh
    }
  }
}
