import 'package:flutter/foundation.dart';
import '../models/modul.dart';
import '../models/materi_data.dart';

class ModulProvider extends ChangeNotifier {
  List<Modul> _modul = [];

  ModulProvider() {
    _loadInitial();
  }

  List<Modul> get modul => _modul;

  void _loadInitial() {
    _modul = semuaModulDummy;
    notifyListeners();
  }

  Modul? getModulById(String id) {
    try {
      return _modul.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  void addModul(Modul m) {
    _modul.add(m);
    notifyListeners();
  }
}
