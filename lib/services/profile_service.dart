import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';

class ProfileService {
  static const String url = 'https://jsonplaceholder.typicode.com/users/1';

  static Future<UserProfile> fetchUserProfile() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);
    } else {
      throw Exception(
          'Gagal memuat data profil (Status: ${response.statusCode})');
    }
  }
}
