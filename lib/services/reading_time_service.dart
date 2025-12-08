import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingTimeService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DateTime? _startTime;
  String? _currentBabId;
  String? _currentModulId;

  // 🆕 Threshold untuk feedback (3 menit = 180 detik)
  static const int feedbackThreshold = 10;

  // Start tracking
  void startReading(String modulId, String babId) {
    _startTime = DateTime.now();
    _currentModulId = modulId;
    _currentBabId = babId;
  }

  // Stop tracking and save
  Future<void> stopReading() async {
    if (_startTime == null || _currentBabId == null) return;

    final duration = DateTime.now().difference(_startTime!);
    final seconds = duration.inSeconds;

    // Minimum 1 second to count
    if (seconds < 1) {
      _reset();
      return;
    }

    // Send to Firebase Analytics
    try {
      await _analytics.logEvent(
        name: 'reading_session',
        parameters: {
          'modul_id': _currentModulId ?? '',
          'bab_id': _currentBabId ?? '',
          'duration_seconds': seconds,
          'user_id': _auth.currentUser?.uid ?? 'anonymous',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Silent fail for analytics
    }

    // Save progress locally
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
      final key = 'reading_time_$_currentBabId';
      final current = prefs.getInt(key) ?? 0;
      await prefs.setInt(key, current + seconds);
    } catch (e) {
      // Silent fail
    }
  }

  // Get reading time for a bab (in seconds)
  Future<int> getReadingTime(String babId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('reading_time_$babId') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // 🆕 Get current session reading time (realtime)
  int getCurrentSessionTime() {
    if (_startTime == null) return 0;
    return DateTime.now().difference(_startTime!).inSeconds;
  }

  // 🆕 Check if should show feedback
  Future<bool> shouldShowFeedback(String babId) async {
    // Check if already shown feedback
    final prefs = await SharedPreferences.getInstance();
    final shownKey = 'feedback_shown_$babId';
    final hasShown = prefs.getBool(shownKey) ?? false;

    if (hasShown) return false;

    // Check if reading time >= threshold
    final currentTime = getCurrentSessionTime();
    return currentTime >= feedbackThreshold;
  }

  // 🆕 Mark feedback as shown for this bab
  Future<void> markFeedbackShown(String babId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('feedback_shown_$babId', true);
    } catch (e) {
      // Silent fail
    }
  }

  // Calculate progress percentage (5 minutes = 100%)
  Future<double> getProgressPercent(String babId,
      {int targetSeconds = 300}) async {
    final seconds = await getReadingTime(babId);
    final percent = (seconds / targetSeconds) * 100;
    return percent > 100 ? 100 : percent;
  }

  // Format seconds to readable time
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

  // Clear all reading progress (for testing/reset)
  Future<void> clearAllProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith('reading_time_'));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      // Silent fail
    }
  }

  // Get total reading time across all babs
  Future<int> getTotalReadingTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith('reading_time_'));
      int total = 0;
      for (final key in keys) {
        total += prefs.getInt(key) ?? 0;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }
}
