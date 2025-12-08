import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileModel? _user;
  bool _isLoading = false;

  ProfileModel? get user => _user;
  bool get isLoading => _isLoading;

  // ==============================
  // LOAD USER DARI FIRESTORE
  // ==============================
  Future<void> loadUser() async {
    if (_isLoading) return; // ✅ GUARD PENTING

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final doc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (doc.exists && doc.data() != null) {
        _user = ProfileModel.fromMap(
          doc.id,
          doc.data()!,
        );
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
  // UPDATE PROFIL (EDIT PROFILE)
  // ==============================
  Future<void> updateProfile(ProfileModel updatedUser) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore.collection('users').doc(uid).update(updatedUser.toMap());

      _user = updatedUser.copyWith(uid: uid);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error updateProfile: $e');
      rethrow;
    }
  }

  // ==============================
  // UPDATE FOTO PROFIL SAJA
  // ==============================
  Future<void> updateProfileImage(String path) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore.collection('users').doc(uid).update({'imagePath': path});

      if (_user != null) {
        _user = _user!.copyWith(imagePath: path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updateProfileImage: $e');
    }
  }

  // ==============================
  // CLEAR DATA SAAT LOGOUT
  // ==============================
  void clear() {
    _user = null;
    _isLoading = false; // ✅ PENTING
    notifyListeners();
  }
}
