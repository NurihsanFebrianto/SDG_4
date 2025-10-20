import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/friend.dart';

class FriendsService {
  static const String _baseUrl = 'https://randomuser.me/api/';

  Future<List<Friend>> fetchSuggestedFriends({int count = 10}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?results=$count'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        return results.map((userData) => Friend.fromJson(userData)).toList();
      } else {
        throw Exception('Failed to load friends: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load friends: $e');
    }
  }

  // Simulate adding friend (since this is a public API, we can't actually add)
  Future<bool> addFriend(Friend friend) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // Simulate removing friend
  Future<bool> removeFriend(String friendId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
