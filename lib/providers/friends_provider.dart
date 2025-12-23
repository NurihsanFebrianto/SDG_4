// friends_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/friend.dart';

class FriendsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Friend> _addedFriends = [];
  List<Friend> _suggestedFriends = [];
  bool _isLoading = false;
  String? _error;

  List<Friend> get addedFriends => _addedFriends;
  List<Friend> get suggestedFriends => _suggestedFriends;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // =====================================================
  // GET CURRENT USER ID
  // =====================================================
  String? get _currentUserId => _auth.currentUser?.uid;

  // =====================================================
  // LOAD FRIENDS FROM FIRESTORE
  // =====================================================
  Future<void> loadFriendsFromFirestore() async {
    if (_currentUserId == null) {
      _error = 'User tidak login';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Ambil data teman dari Firestore
      final snapshot = await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('friends')
          .orderBy('addedAt', descending: true)
          .get();

      _addedFriends =
          snapshot.docs.map((doc) => Friend.fromJson(doc.data())).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Gagal memuat teman: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // LOAD SUGGESTED FRIENDS FROM FIRESTORE USERS COLLECTION
  // =====================================================
  Future<void> loadSuggestedFriends() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load daftar teman yang sudah ditambahkan
      await loadFriendsFromFirestore();

      // Load suggested friends dari collection 'users'
      final usersSnapshot = await _firestore.collection('users').get();

      final addedIds = _addedFriends.map((f) => f.id).toSet();

      _suggestedFriends = usersSnapshot.docs
          .where((doc) => doc.id != _currentUserId) // Exclude current user
          .map((doc) {
            final data = doc.data();
            return Friend(
              id: doc.id,
              name: data['name'] ?? 'Unknown',
              email: data['email'] ?? 'Unknown',
              phone: data['phone'] ?? 'N/A',
              location: data['alamat'] ?? data['asalSekolah'] ?? 'Unknown',
              picture: data['imagePath'] ??
                  'https://via.placeholder.com/150', // Default placeholder jika kosong
              registeredDate: data['createdAt'] != null
                  ? (data['createdAt'] as Timestamp).toDate()
                  : DateTime.now(),
            );
          })
          .where((friend) =>
              !addedIds.contains(friend.id)) // Filter yang sudah ditambahkan
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Gagal memuat rekomendasi: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // ADD FRIEND TO FIRESTORE
  // =====================================================
  Future<void> addFriend(Friend friend) async {
    if (_currentUserId == null) return;

    try {
      // Simpan ke Firestore
      await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('friends')
          .doc(friend.id)
          .set(friend.toJson());

      // Update local state
      _addedFriends.add(friend);
      _suggestedFriends.removeWhere((f) => f.id == friend.id);

      notifyListeners();
    } catch (e) {
      print('❌ Error adding friend: $e');
      _error = 'Gagal menambahkan teman';
      notifyListeners();
    }
  }

  // =====================================================
  // REMOVE FRIEND FROM FIRESTORE
  // =====================================================
  Future<void> removeFriend(String friendId) async {
    if (_currentUserId == null) return;

    try {
      // Hapus dari Firestore
      await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('friends')
          .doc(friendId)
          .delete();

      // Update local state
      final removedFriend = _addedFriends.firstWhere((f) => f.id == friendId);
      _addedFriends.removeWhere((f) => f.id == friendId);
      _suggestedFriends.add(removedFriend);

      notifyListeners();
    } catch (e) {
      print('❌ Error removing friend: $e');
      _error = 'Gagal menghapus teman';
      notifyListeners();
    }
  }

  // =====================================================
  // CHECK IF FRIEND EXISTS
  // =====================================================
  bool isFriendAdded(String friendId) {
    return _addedFriends.any((f) => f.id == friendId);
  }

  // Refresh semua data friends (added + suggested)
  Future<void> refreshFriends() async {
    await loadSuggestedFriends(); // Ini sudah include loadFriendsFromFirestore()
  }

  // Bersihkan data friends saat logout
  void clearFriends() {
    _addedFriends = [];
    _suggestedFriends = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
