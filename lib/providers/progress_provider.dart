import 'package:flutter/foundation.dart';
import '../models/progress_model.dart';
import '../services/progress_service.dart';

class ProgressProvider with ChangeNotifier {
  StudyProgress? _progress;
  List<StudyProgress> _allProgress = [];
  bool _isLoading = false;
  String? _error;

  StudyProgress? get progress => _progress;
  List<StudyProgress> get allProgress => _allProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 🔹 Ambil satu progres terakhir user
  Future<void> getProgress(String userId) async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('📡 Mengambil progres terakhir untuk userId: $userId');
      _progress = await ProgressService.fetchProgress(userId);
      print('✅ Progres ditemukan: ${_progress?.subject}');
    } catch (e) {
      _error = e.toString();
      print('❌ Error di getProgress: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Ambil semua progres user (untuk halaman "Lihat Semua")
  Future<void> getAllProgress(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('📡 Mengambil semua progres untuk userId: $userId');
      _allProgress = await ProgressService.fetchAllProgress(userId);
      print('✅ Jumlah progres ditemukan: ${_allProgress.length}');

      if (_allProgress.isNotEmpty) {
        _progress = _allProgress.last;
        print('✅ Progres terakhir: ${_progress!.subject}');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error di getAllProgress: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
