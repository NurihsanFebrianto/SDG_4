import 'package:aplikasi_materi_kurikulum/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController genderCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController schoolCtrl;
  final _formKey = GlobalKey<FormState>();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    genderCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    schoolCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<ProfileProvider>().user;
      if (user != null) {
        nameCtrl.text = user.name;
        emailCtrl.text = user.email;
        phoneCtrl.text = user.phone;
        genderCtrl.text = user.jenisKelamin;
        addressCtrl.text = user.alamat;
        schoolCtrl.text = user.asalSekolah;
      }
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    genderCtrl.dispose();
    addressCtrl.dispose();
    schoolCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final user = provider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            _buildSectionTitle('Informasi Dasar'),
            const SizedBox(height: 16),
            _buildField(
              fieldKey: const ValueKey('name_field'),
              label: "Nama Lengkap",
              icon: Icons.person_outline,
              controller: nameCtrl,
              color: const Color(0xFF3D7EBB),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildField(
              fieldKey: const ValueKey('email_field'),
              label: "Email",
              icon: Icons.email_outlined,
              controller: emailCtrl,
              color: const Color(0xFF3D7EBB),
              isEnabled: false,
              helperText: 'Email tidak dapat diubah',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Kontak'),
            const SizedBox(height: 16),
            _buildField(
              label: "Nomor Telepon",
              icon: Icons.phone_outlined,
              controller: phoneCtrl,
              color: const Color(0xFF4CAF50),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildField(
              label: "Jenis Kelamin",
              icon: Icons.wc_outlined,
              controller: genderCtrl,
              color: const Color(0xFF03A9F4),
            ),
            const SizedBox(height: 24),
            _buildField(
              label: "Alamat",
              icon: Icons.location_on_outlined,
              controller: addressCtrl,
              color: const Color(0xFFE91E63),
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),
            _buildField(
              label: "Asal Sekolah",
              icon: Icons.business_outlined,
              controller: schoolCtrl,
              color: const Color(0xFF9C27B0),
            ),
            const SizedBox(height: 32),
            _buildActionButtons(context, provider, user),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E3A5F),
      ),
    );
  }

  Widget _buildField({
    Key? fieldKey,
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required Color color,
    bool isEnabled = true,
    String? helperText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        key: fieldKey,
        controller: controller,
        enabled: isEnabled,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(
          fontSize: 15,
          color: isEnabled ? const Color(0xFF1E3A5F) : Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isEnabled ? color : Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
          helperText: helperText,
          helperStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          filled: true,
          fillColor: isEnabled ? Colors.white : Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: color, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, ProfileProvider provider, ProfileModel user) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1E3A5F),
              side: const BorderSide(color: Color(0xFF1E3A5F), width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            key: const ValueKey('save_button'), // ✅ TAMBAH INI
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A5F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
              shadowColor: const Color(0xFF1E3A5F).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _saveProfile(context, provider, user),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_circle_outline, size: 20),
                SizedBox(width: 8),
                Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile(
      BuildContext context, ProfileProvider provider, ProfileModel user) async {
    if (_formKey.currentState?.validate() ?? false) {
      final updated = user.copyWith(
        name: nameCtrl.text,
        phone: phoneCtrl.text,
        jenisKelamin: genderCtrl.text,
        alamat: addressCtrl.text,
        asalSekolah: schoolCtrl.text,
        imagePath: user.imagePath,
      );

      // ===== ✅ WAJIB AWAIT =====
      await context.read<ProfileProvider>().updateProfile(updated);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "Profil berhasil diperbarui!",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      Navigator.pop(context);
    }
  }
}
