// lib/providers/auth_provider.dart
import 'package:aplikasi_materi_kurikulum/services/auth_preferens.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final AuthPreferens _authPref = AuthPreferens();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Load status login dari SharedPreferences
  Future<void> loadLoginStatus() async {
    _isLoggedIn = await _authPref.isLoggedIn();
    notifyListeners();
  }

  // Login
  Future<void> login() async {
    await _authPref.login();
    _isLoggedIn = true;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    await _authPref.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
