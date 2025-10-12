import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferens {
  static const String loginStatusKey = 'isLoggedIn';

  // Login (simpan status login saja)
  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginStatusKey, true);
  }

  // Logout (hapus status login)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginStatusKey, false);
  }

  // Cek status login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginStatusKey) ?? false;
  }
}
