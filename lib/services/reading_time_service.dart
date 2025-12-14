import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingTimeService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DateTime? _startTime;
  String? _currentBabId;
  String? _currentModulId;

  static const int feedbackThreshold = 10;

  // ✅ Get current userId
  String _getCurrentUserId() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    return user.uid;
  }

  // ✅ Generate user-specific key
  String _getUserKey(String key) {
    final userId = _getCurrentUserId();
    return '${key}_$userId';
  }

  void startReading(String modulId, String babId) {
    _startTime = DateTime.now();
    _currentModulId = modulId;
    _currentBabId = babId;
  }

  Future<void> stopReading() async {
    if (_startTime == null || _currentBabId == null) return;

    final duration = DateTime.now().difference(_startTime!);
    final seconds = duration.inSeconds;

    if (seconds < 1) {
      _reset();
      return;
    }

    try {
      await _analytics.logEvent(
        name: 'reading_session',
        parameters: {
          'modul_id': _currentModulId ?? '',
          'bab_id': _currentBabId ?? '',
          'duration_seconds': seconds,
          'user_id': _getCurrentUserId(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Silent fail for analytics
    }

    await _saveProgressLocally(seconds);
    _reset();
  }

  void _reset() {
    _startTime = null;
    _currentBabId = null;
    _currentModulId = null;
  }

  Future<void> _saveProgressLocally(int seconds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // ✅ User-specific key
      final key = _getUserKey('reading_time_$_currentBabId');
      final current = prefs.getInt(key) ?? 0;
      await prefs.setInt(key, current + seconds);
    } catch (e) {
      // Silent fail
    }
  }

  // ✅ Get reading time for a bab (user-specific)
  Future<int> getReadingTime(String babId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getUserKey('reading_time_$babId');
      return prefs.getInt(key) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  int getCurrentSessionTime() {
    if (_startTime == null) return 0;
    return DateTime.now().difference(_startTime!).inSeconds;
  }

  // ✅ Check if should show feedback (user-specific)
  Future<bool> shouldShowFeedback(String babId) async {
    final prefs = await SharedPreferences.getInstance();
    final shownKey = _getUserKey('feedback_shown_$babId');
    final hasShown = prefs.getBool(shownKey) ?? false;

    if (hasShown) return false;

    final currentTime = getCurrentSessionTime();
    return currentTime >= feedbackThreshold;
  }

  // ✅ Mark feedback as shown (user-specific)
  Future<void> markFeedbackShown(String babId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getUserKey('feedback_shown_$babId');
      await prefs.setBool(key, true);
    } catch (e) {
      // Silent fail
    }
  }

  Future<double> getProgressPercent(String babId,
      {int targetSeconds = 300}) async {
    final seconds = await getReadingTime(babId);
    final percent = (seconds / targetSeconds) * 100;
    return percent > 100 ? 100 : percent;
  }

  String formatTime(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes < 60) {
      return secs > 0 ? '${minutes}m ${secs}s' : '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }

  // ✅ Clear progress for current user only
  Future<void> clearAllProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _getCurrentUserId();
      final keys = prefs.getKeys().where(
          (k) => k.startsWith('reading_time_') && k.endsWith('_$userId'));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      // Silent fail
    }
  }

  // ✅ Get total reading time for current user
  Future<int> getTotalReadingTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _getCurrentUserId();
      final keys = prefs.getKeys().where(
          (k) => k.startsWith('reading_time_') && k.endsWith('_$userId'));
      int total = 0;
      for (final key in keys) {
        total += prefs.getInt(key) ?? 0;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // ✅ Clear all data for current user on logout
  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _getCurrentUserId();

      // Remove all keys containing userId
      final keys = prefs.getKeys().where((k) => k.endsWith('_$userId'));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      // Silent fail
    }
  }
}
