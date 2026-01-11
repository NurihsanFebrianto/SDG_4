import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileProvider extends ChangeNotifier {
  /// 🔑 FLAG KONTROL FIREBASE
  final bool enableFirebase;

  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  ProfileModel? _user;
  bool _isLoading = false;

  ProfileProvider({this.enableFirebase = true}) {
    if (enableFirebase) {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
    }
  }

  ProfileModel? get user => _user;
  bool get isLoading => _isLoading;

  // ==============================
  // LOAD USER DARI FIRESTORE
  // ==============================
  Future<void> loadUser() async {
    if (!enableFirebase || _auth == null || _firestore == null) return;
    if (_isLoading) return;

    final currentUser = _auth!.currentUser;
    if (currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final doc =
          await _firestore!.collection('users').doc(currentUser.uid).get();

      if (doc.exists && doc.data() != null) {
        _user = ProfileModel.fromMap(doc.id, doc.data()!);
      } else {
        _user = null;
      }
    } catch (e) {
      debugPrint('❌ Error loadUser: $e');
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==============================
  // UPDATE PROFIL
  // ==============================
  Future<void> updateProfile(ProfileModel updatedUser) async {
    /// 🧪 MODE TEST → TANPA FIREBASE
    if (!enableFirebase || _auth == null || _firestore == null) {
      _user = updatedUser;
      notifyListeners();
      return;
    }

    try {
      final uid = _auth!.currentUser?.uid;
      if (uid == null) return;

      await _firestore!
          .collection('users')
          .doc(uid)
          .update(updatedUser.toMap());

      _user = updatedUser.copyWith(uid: uid);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error updateProfile: $e');
      rethrow;
    }
  }

  // ==============================
  // UPDATE FOTO PROFIL
  // ==============================
  Future<void> updateProfileImage(String path) async {
    if (!enableFirebase || _auth == null || _firestore == null) {
      if (_user != null) {
        _user = _user!.copyWith(imagePath: path);
        notifyListeners();
      }
      return;
    }

    try {
      final uid = _auth!.currentUser?.uid;
      if (uid == null) return;

      await _firestore!
          .collection('users')
          .doc(uid)
          .update({'imagePath': path});

      if (_user != null) {
        _user = _user!.copyWith(imagePath: path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updateProfileImage: $e');
    }
  }

  // ==============================
  // ✅ KHUSUS TESTING (MOCK DATA)
  // ==============================
  void setUser(ProfileModel profile) {
    _user = profile;
    _isLoading = false;
    notifyListeners();
  }

  // ==============================
  // CLEAR DATA SAAT LOGOUT
  // ==============================
  void clear() {
    _user = null;
    _isLoading = false;
    notifyListeners();
  }
}
