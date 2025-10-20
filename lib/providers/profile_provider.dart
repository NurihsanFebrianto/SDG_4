import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile? user;
  bool isLoading = false;

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await ProfileService.fetchUserProfile();
      if (kDebugMode) {
        print('✅ Profil berhasil dimuat: ${result.name}');
      }
      user = result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Gagal memuat profil: $e');
      }
      user = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
