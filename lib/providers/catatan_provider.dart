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
    _items = await DatabaseService.instance.getAllCatatan();
    notifyListeners();
  }

  Future<void> tambahCatatan(String isi,
      {String? modulId, String? babId}) async {
    final newCatatan = Catatan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isi: isi,
      modulId: modulId,
      babId: babId,
    );
    await DatabaseService.instance.insertCatatan(newCatatan);
    _items.insert(0, newCatatan);
    notifyListeners();
  }

  Future<void> updateCatatan(String id, String isiBaru) async {
    final index = _items.indexWhere((catatan) => catatan.id == id);
    if (index != -1) {
      _items[index].isi = isiBaru;
      await DatabaseService.instance.updateCatatan(_items[index]);
      notifyListeners();
    }
  }

  Future<void> hapusCatatan(String id) async {
    await DatabaseService.instance.deleteCatatan(id);
    _items.removeWhere((c) => c.id == id);
    notifyListeners();
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
}
