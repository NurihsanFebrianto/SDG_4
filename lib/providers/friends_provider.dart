import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../services/friends_service.dart';

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

  // Load suggested friends from API
  Future<void> loadSuggestedFriends() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _suggestedFriends = await _friendsService.fetchSuggestedFriends();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _suggestedFriends = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add friend to added friends list
  Future<void> addFriend(Friend friend) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _friendsService.addFriend(friend);
      if (success) {
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

  // Remove friend from added friends list
  Future<void> removeFriend(String friendId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final friend = _addedFriends.firstWhere((f) => f.id == friendId);
      final success = await _friendsService.removeFriend(friendId);
      if (success) {
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

  // Check if user is already added as friend
  bool isFriendAdded(String friendId) {
    return _addedFriends.any((friend) => friend.id == friendId);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
