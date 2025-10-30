import 'package:flutter/foundation.dart';
import '../models/modul.dart';
import '../services/modul_service.dart';

class ModulProvider extends ChangeNotifier {
  List<Modul> _modul = [];
  bool _isLoading = false;
  String _error = '';
  final ModulService _service = ModulService();

  List<Modul> get modul => _modul;
  bool get isLoading => _isLoading;
  String get error => _error;

  ModulProvider() {
    print('🔄 PROVIDER DIJALANKAN');
    _loadModul();
  }

  Future<void> _loadModul() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('📡 LOADING DATA DARI API...');
      _modul = await _service.fetchModulFromApi();
      _error = '';
      print('✅ BERHASIL LOAD: ${_modul.length} MODUL');
    } catch (e) {
      print('❌ GAGAL LOAD: $e');
      _error = e.toString();
      _modul = _service.getDummyModul();
      print('🔄 PAKAI DATA FALLBACK');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadModul();
  }
}
