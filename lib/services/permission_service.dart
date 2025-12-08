import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
import '../providers/profile_provider.dart';

class PermissionService {
  static int cameraDenied = 0;
  static int galleryDenied = 0;
  static const int maxAttempts = 3;

  /// FUNGSI UTAMA
  static Future<void> pickImage(
      BuildContext context, ImageSource source) async {
    if (!context.mounted) return;

    final Permission permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;

    /// ✅ SUDAH DIIZINKAN → LANGSUNG PAKAI
    if (await permission.isGranted) {
      await _pick(context, source);
      return;
    }

    /// ✅ JIKA SUDAH DON’T ALLOW 2x → LANGSUNG SETTINGS (KE-3)
    final deniedCount =
        source == ImageSource.camera ? cameraDenied : galleryDenied;
    if (deniedCount >= maxAttempts - 1) {
      await _openSettingsDialog(context);
      return;
    }

    /// 🧠 DIALOG EDUKASI (TIDAK DIHITUNG)
    final proceed = await _showRationaleDialog(context, source);
    if (!proceed) return;

    /// 🔐 REQUEST PERMISSION SISTEM (ALLOW / DON’T ALLOW)
    final status = await permission.request();

    /// ❌ DON’T ALLOW
    if (!status.isGranted) {
      _increaseCounter(source);
      return;
    }

    /// ✅ ALLOW → RESET COUNTER & PICK IMAGE
    _resetCounter(source);
    await _pick(context, source);
  }

  /// DIALOG EDUKASI
  static Future<bool> _showRationaleDialog(
      BuildContext context, ImageSource source) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text(
              source == ImageSource.camera
                  ? "Akses Kamera Diperlukan"
                  : "Akses Galeri Diperlukan",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              source == ImageSource.camera
                  ? "Aplikasi memerlukan akses Kamera untuk mengambil "
                      "foto yang digunakan sebagai foto profil."
                  : "Aplikasi memerlukan akses Galeri untuk memilih "
                      "foto yang digunakan sebagai foto profil.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Lanjut"),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// DIALOG SETTINGS
  static Future<void> _openSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Izin Diperlukan"),
        content: const Text(
          "Anda telah menolak izin beberapa kali.\n\n"
          "Silakan aktifkan izin Kamera atau Galeri secara manual "
          "melalui Pengaturan Aplikasi.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openAppSettings();
            },
            child: const Text("Buka Pengaturan"),
          ),
        ],
      ),
    );
  }

  /// PICK IMAGE
  static Future<void> _pick(BuildContext context, ImageSource source) async {
    final picked =
        await ImagePicker().pickImage(source: source, imageQuality: 80);

    if (!context.mounted || picked == null) return;
    context.read<ProfileProvider>().updateProfileImage(picked.path);
  }

  /// COUNTER UTIL
  static bool _isExceeded(ImageSource source) {
    return source == ImageSource.camera
        ? cameraDenied >= maxAttempts
        : galleryDenied >= maxAttempts;
  }

  static void _increaseCounter(ImageSource source) {
    source == ImageSource.camera ? cameraDenied++ : galleryDenied++;
  }

  static void _resetCounter(ImageSource source) {
    source == ImageSource.camera ? cameraDenied = 0 : galleryDenied = 0;
  }
}
