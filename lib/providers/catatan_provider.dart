import 'package:flutter/material.dart';
import '../models/catatan.dart';
import '../services/database_service.dart';

class CatatanProvider with ChangeNotifier {
  List<Catatan> _items = [];

  List<Catatan> get daftarCatatan => List.unmodifiable(_items);

  CatatanProvider() {
    _loadCatatanFromDB();
  }

  Future<void> _loadCatatanFromDB() async {
    try {
      _items = await DatabaseService.instance.getAllCatatan();
      notifyListeners();
    } catch (e) {
      print('Error loading catatan: $e');
      _items = [];
      notifyListeners();
    }
  }

  Future<void> tambahCatatan(String isi,
      {String? modulId, String? babId}) async {
    try {
      final newCatatan = Catatan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isi: isi,
        modulId: modulId,
        babId: babId,
      );

      await DatabaseService.instance.insertCatatan(newCatatan);
      _items.insert(0, newCatatan); // Tambah di awal list
      notifyListeners();

      print('Catatan berhasil ditambah: ${newCatatan.isi}');
    } catch (e) {
      print('Error tambah catatan: $e');
    }
  }

  Future<void> updateCatatan(String id, String isiBaru) async {
    try {
      final index = _items.indexWhere((catatan) => catatan.id == id);
      if (index != -1) {
        _items[index].isi = isiBaru;
        await DatabaseService.instance.updateCatatan(_items[index]);
        notifyListeners();
        print('Catatan berhasil diupdate: $isiBaru');
      }
    } catch (e) {
      print('Error update catatan: $e');
    }
  }

  Future<void> hapusCatatan(String id) async {
    try {
      await DatabaseService.instance.deleteCatatan(id);
      _items.removeWhere((c) => c.id == id);
      notifyListeners();
      print('Catatan berhasil dihapus: $id');
    } catch (e) {
      print('Error hapus catatan: $e');
    }
  }

  List<Catatan> catatanUntuk(String? modulId, String? babId) {
    if (modulId == null && babId == null) return daftarCatatan;

    return _items.where((c) {
      if (modulId != null && babId != null) {
        return c.modulId == modulId && c.babId == babId;
      } else if (modulId != null) {
        return c.modulId == modulId;
      } else if (babId != null) {
        return c.babId == babId;
      }
      return false;
    }).toList();
  }

  // Method untuk refresh data
  Future<void> refreshCatatan() async {
    await _loadCatatanFromDB();
  }
}
