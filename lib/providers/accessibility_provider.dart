// lib/providers/accessibility_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityProvider with ChangeNotifier {
  static const String _textScaleKey = 'text_scale_factor';
  static const String _brightnessKey = 'app_brightness';
  static const String _hapticKey = 'haptic_feedback';

  double _textScaleFactor = 1.0;
  double _appBrightness = 0.5; // 0.0 = dark, 1.0 = bright
  bool _hapticEnabled = true;

  double get textScaleFactor => _textScaleFactor;
  double get appBrightness => _appBrightness;
  bool get hapticEnabled => _hapticEnabled;

  // Text scale presets
  static const Map<String, double> textScalePresets = {
    'Kecil': 0.85,
    'Normal': 1.0,
    'Besar': 1.15,
    'Sangat Besar': 1.3,
  };

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _textScaleFactor = prefs.getDouble(_textScaleKey) ?? 1.0;
    _appBrightness = prefs.getDouble(_brightnessKey) ?? 0.5;
    _hapticEnabled = prefs.getBool(_hapticKey) ?? true;
    notifyListeners();
  }

  // Set text scale factor
  Future<void> setTextScale(double scale) async {
    _textScaleFactor = scale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_textScaleKey, scale);
  }

  // Set app brightness (overlay filter)
  Future<void> setBrightness(double brightness) async {
    _appBrightness = brightness.clamp(0.0, 1.0);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_brightnessKey, _appBrightness);
  }

  // Toggle haptic feedback
  Future<void> setHapticEnabled(bool enabled) async {
    _hapticEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticKey, enabled);
  }

  // Get current brightness overlay color
  Color getBrightnessOverlay() {
    // Convert 0.0-1.0 to brightness overlay
    // 0.5 = no overlay (normal)
    // 0.0 = dark overlay (for low vision)
    // 1.0 = bright overlay (for bright environments)

    if (_appBrightness < 0.5) {
      // Darker overlay
      final darkness = (0.5 - _appBrightness) * 2; // 0.0 to 1.0
      return Colors.black.withOpacity(darkness * 0.4);
    } else if (_appBrightness > 0.5) {
      // Brighter overlay
      final lightness = (_appBrightness - 0.5) * 2; // 0.0 to 1.0
      return Colors.white.withOpacity(lightness * 0.3);
    }
    return Colors.transparent;
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    _textScaleFactor = 1.0;
    _appBrightness = 0.5;
    _hapticEnabled = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_textScaleKey);
    await prefs.remove(_brightnessKey);
    await prefs.remove(_hapticKey);
  }
}
