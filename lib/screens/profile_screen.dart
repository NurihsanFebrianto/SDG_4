import 'dart:io';
import 'package:aplikasi_materi_kurikulum/models/profile.dart';
import 'package:aplikasi_materi_kurikulum/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../services/permission_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.user == null) {
      return const Scaffold(
        body: Center(child: Text('Data profil tidak ditemukan')),
      );
    }

    final user = provider.user!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(context, user),
            const SizedBox(height: 16),
            _buildInfoSection(context, user),
            const SizedBox(height: 16),
            _buildLogoutButton(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeaderSection(BuildContext context, ProfileModel user) {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1E3A5F),
          Color(0xFF2D5F8D),
        ],
      ),
    ),
    child: Column(
      children: [
        const SizedBox(height: 24),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: const Color(0xFF3D7EBB),
                  backgroundImage: user.imagePath.isNotEmpty
                      ? FileImage(File(user.imagePath))
                      : null,
                  child: user.imagePath.isEmpty
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : "U",
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB74D),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.camera_alt,
                      size: 20, color: Colors.white),
                  onPressed: () => _showPicker(context),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Siswa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    ),
  );
}

Widget _buildInfoSection(BuildContext context, ProfileModel user) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Informasi Pribadi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D7EBB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF3D7EBB).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Color(0xFF3D7EBB),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3D7EBB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildInfoItem(
            icon: Icons.email_outlined,
            label: 'Email',
            value: user.email,
            color: const Color(0xFF3D7EBB),
          ),
          _buildInfoItem(
            icon: Icons.phone_outlined,
            label: 'Telepon',
            value: user.phone,
            color: const Color(0xFF4CAF50),
          ),
          _buildInfoItem(
            icon: Icons.wc_outlined,
            label: 'Jenis Kelamin',
            value: user.jenisKelamin,
            color: const Color(0xFF03A9F4),
          ),
          _buildInfoItem(
            icon: Icons.school_outlined,
            label: 'Asal Sekolah',
            value: user.asalSekolah,
            color: const Color(0xFFFF9800),
          ),
          _buildInfoItem(
            icon: Icons.location_on_outlined,
            label: 'Alamat',
            value: user.alamat,
            color: const Color(0xFFE91E63),
            isLast: true,
          ),
        ],
      ),
    ),
  );
}

Widget _buildInfoItem({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
  bool isLast = false,
}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(20, 16, 20, isLast ? 20 : 16),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1E3A5F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildDivider() {
  return Padding(
    padding: const EdgeInsets.only(left: 72),
    child: Divider(
      height: 1,
      color: Colors.grey.shade200,
    ),
  );
}

Widget _buildLogoutButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: InkWell(
      onTap: () => _showLogoutDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE53935)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.logout_rounded,
              color: Color(0xFFE53935),
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Keluar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: const [
            Icon(
              Icons.logout_rounded,
              color: Color(0xFFE53935),
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'Keluar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF5A5A5A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A5A5A),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              _handleLogout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _handleLogout(BuildContext context) async {
  // ✅ CLEAR DATA PROFILE DARI PROVIDER
  context.read<ProfileProvider>().clear();

  // ✅ SIGN OUT DARI FIREBASE
  await FirebaseAuth.instance.signOut();

  // ✅ PINDAH KE LOGIN & HAPUS NAVIGATION STACK
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
    (route) => false,
  );

  // ✅ FEEDBACK KE USER
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Anda telah keluar'),
      backgroundColor: Color(0xFF4CAF50),
      duration: Duration(seconds: 2),
    ),
  );
}

void _showPicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pilih Foto Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
            const SizedBox(height: 20),
            _buildPickerOption(
              context: context,
              icon: Icons.photo_library_rounded,
              title: "Pilih dari Galeri",
              color: const Color(0xFF3D7EBB),
              onTap: () {
                Navigator.pop(context);
                PermissionService.pickImage(context, ImageSource.gallery);
              },
            ),
            const SizedBox(height: 12),
            _buildPickerOption(
              context: context,
              icon: Icons.camera_alt_rounded,
              title: "Ambil dari Kamera",
              color: const Color(0xFFFFB74D),
              onTap: () {
                Navigator.pop(context);
                PermissionService.pickImage(context, ImageSource.camera);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}

Widget _buildPickerOption({
  required BuildContext context,
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}
