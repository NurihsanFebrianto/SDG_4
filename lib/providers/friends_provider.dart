import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/friend.dart';
import '../services/friends_service.dart';
import '../services/database_service.dart';

class FriendsProvider with ChangeNotifier {
  final FriendsService _friendsService = FriendsService();

  List<Friend> _addedFriends = [];
  List<Friend> _suggestedFriends = [];
  bool _isLoading = false;
  String? _error;

  List<Friend> get addedFriends => _addedFriends;
  List<Friend> get suggestedFriends => _suggestedFriends;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ✅ Load friends from local DB on init
  FriendsProvider() {
    _loadAddedFriendsFromDB();
  }

  // ✅ Load added friends from SQLite (user-specific)
  Future<void> _loadAddedFriendsFromDB() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final friendMaps = await DatabaseService.instance.getAllFriends();
      _addedFriends = friendMaps.map((map) => Friend.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading friends from DB: $e');
    }
  }

  // Load suggested friends from API
  Future<void> loadSuggestedFriends() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final allSuggested = await _friendsService.fetchSuggestedFriends();

      // ✅ Filter out already added friends
      _suggestedFriends = allSuggested.where((suggested) {
        return !_addedFriends.any((added) => added.id == suggested.id);
      }).toList();

      _error = null;
    } catch (e) {
      _error = e.toString();
      _suggestedFriends = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Add friend to added friends list (save to DB)
  Future<void> addFriend(Friend friend) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _friendsService.addFriend(friend);
      if (success) {
        // Save to local DB (with userId)
        await DatabaseService.instance.insertFriend(friend.toMap());

        _addedFriends.add(friend);
        _suggestedFriends.removeWhere((f) => f.id == friend.id);
        _error = null;
      }
    } catch (e) {
      _error = 'Failed to add friend: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Remove friend from added friends list (delete from DB)
  Future<void> removeFriend(String friendId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final friend = _addedFriends.firstWhere((f) => f.id == friendId);
      final success = await _friendsService.removeFriend(friendId);

      if (success) {
        // Delete from local DB
        await DatabaseService.instance.deleteFriend(friendId);

        _addedFriends.removeWhere((f) => f.id == friendId);
        _suggestedFriends.add(friend);
        _error = null;
      }
    } catch (e) {
      _error = 'Failed to remove friend: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFriendAdded(String friendId) {
    return _addedFriends.any((friend) => friend.id == friendId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ✅ Refresh friends list (reload from DB)
  Future<void> refreshFriends() async {
    await _loadAddedFriendsFromDB();
  }

  // ✅ Clear all friends (on logout/switch account)
  void clearFriends() {
    _addedFriends.clear();
    _suggestedFriends.clear();
    notifyListeners();
  }
}
