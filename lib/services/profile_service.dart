import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';

class ProfileService {
  static const String url ='https://68f3be64fd14a9fcc429b996.mockapi.io/education/user';

  static Future<UserProfile> fetchUserProfile() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data[0]);
    } else {
      throw Exception(
        'Gagal memuat data profil (Status: ${response.statusCode})',
      );
    }
  }
}
