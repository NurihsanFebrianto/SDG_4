import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;

  bool get isLoggedIn => _user != null;
  UserData? get data => _user;

  void login({
    required String nama,
    required int umur,
    required String jenisKelamin,
  }) {
    _user = UserData(nama: nama, umur: umur, jenisKelamin: jenisKelamin);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void updateProfil({
    required String nama,
    required int umur,
    required String jenisKelamin,
  }) {
    if (_user == null) return;
    _user!
      ..nama = nama
      ..umur = umur
      ..jenisKelamin = jenisKelamin;
    notifyListeners();
  }

  void setMateriTerakhir({
    required String modulId,
    required String modulNama,
    required String babId,
    required String babNama,
  }) {
    if (_user == null) return;
    _user!
      ..modulTerakhirId = modulId
      ..babTerakhirId = babId
      ..modulTerakhirNama = modulNama
      ..babTerakhirNama = babNama;
    notifyListeners();
  }

  void resetMateriTerakhir() {
    if (_user == null) return;
    _user!
      ..modulTerakhirId = null
      ..babTerakhirId = null
      ..modulTerakhirNama = null
      ..babTerakhirNama = null
      ..lastScrollOffset = null;
    notifyListeners();
  }

  void setLastScrollOffset({
    required String modulId,
    required String babId,
    required double offset,
  }) {
    if (_user == null) return;
    _user!
      ..modulTerakhirId = modulId
      ..babTerakhirId = babId
      ..modulTerakhirNama = _user!.modulTerakhirNama
      ..babTerakhirNama = _user!.babTerakhirNama
      ..lastScrollOffset = offset;
    notifyListeners();
  }
}
