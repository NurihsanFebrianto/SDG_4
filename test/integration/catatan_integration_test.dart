import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_materi_kurikulum/models/catatan.dart';

void main() {
  group('Integrated Test - Catatan Model', () {
    // ============================
    // 5 TEST BERHASIL (SUCCESS)
    // ============================

    test('1. SUCCESS: Catatan.toMap() menghasilkan Map yang valid', () {
      final catatan = Catatan(
        id: 'test-001',
        isi: 'Catatan untuk testing toMap',
        modulId: 'fisika',
        babId: '3',
      );

      final result = catatan.toMap();
      expect(result['id'], 'test-001');
      expect(result['isi'], 'Catatan untuk testing toMap');
    });

    test('2. SUCCESS: Catatan.fromMap() mengembalikan objek Catatan yang valid',
        () {
      final mapData = {
        'id': 'test-002',
        'isi': 'Catatan dari map data',
        'modulId': 'kimia',
        'babId': '5',
        'createdAt': '2024-01-01T10:00:00.000Z',
      };

      final catatan = Catatan.fromMap(mapData);
      expect(catatan.id, 'test-002');
      expect(catatan.isi, 'Catatan dari map data');
    });

    test('3. SUCCESS: Model Catatan dengan createdAt otomatis', () {
      final catatan = Catatan(
        id: 'auto-date-001',
        isi: 'Catatan dengan tanggal otomatis',
      );

      expect(catatan.createdAt, isA<DateTime>());
    });

    test('4. SUCCESS: Model Catatan dengan modulId dan babId opsional', () {
      final catatan1 = Catatan(
        id: 'optional-001',
        isi: 'Catatan tanpa modul dan bab',
      );

      expect(catatan1.modulId, isNull);
      expect(catatan1.babId, isNull);
    });

    test('5. SUCCESS: Round-trip serialization Catatan', () {
      final originalCatatan = Catatan(
        id: 'roundtrip-001',
        isi: 'Catatan untuk round-trip test',
        modulId: 'geografi',
        babId: '4',
        createdAt: DateTime(2024, 1, 15, 10, 30, 0),
      );

      final map = originalCatatan.toMap();
      final deserialized = Catatan.fromMap(map);

      expect(deserialized.id, originalCatatan.id);
      expect(deserialized.isi, originalCatatan.isi);
    });

    // ============================
    // 3 TEST GAGAL (FAILURE) - TANPA EXPECT, LANGSUNG ERROR
    // ============================

    test('6. FAIL: Division by zero error', () {
      // Test ini akan FAIL dengan sendirinya
      final a = 10;
      final b = 0;

      // LANGSUNG error, tidak pakai expect(throwsA)
      final result = a ~/ b; // Ini akan crash
      print('Ini tidak akan pernah dieksekusi: $result');
    });

    test('7. FAIL: Null access error', () {
      // Test ini akan FAIL dengan sendirinya
      String? nullableString = null;

      // LANGSUNG error, tidak pakai expect(throwsA)
      final length = nullableString!.length; // Ini akan crash
      print('Ini tidak akan pernah dieksekusi: $length');
    });

    test('8. FAIL: List index out of bounds', () {
      // Test ini akan FAIL dengan sendirinya
      final list = [1, 2, 3];

      // LANGSUNG error, tidak pakai expect(throwsA)
      final value = list[999]; // Ini akan crash
      print('Ini tidak akan pernah dieksekusi: $value');
    });
  });
}
