import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/accessibility_provider.dart';
import 'profile_screen.dart';

// Academic Color Scheme
const Color primaryDarkBlue = Color(0xFF0A3D62);
const Color primaryBlue = Color(0xFF1E3A8A);
const Color primaryLightBlue = Color(0xFF0D47A1);
const Color secondaryCyan = Color(0xFF0EA5E9);
const Color secondaryBlue = Color(0xFF0284C7);
const Color secondaryTeal = Color(0xFF14B8A6);
const Color accentAmber = Color(0xFFFBF24);
const Color accentOrange = Color(0xFFF59E0B);
const Color successGreen = Color(0xFF10B981);
const Color warningYellow = Color(0xFFF59E0B);
const Color errorRed = Color(0xFFEF4444);
const Color neutralGray = Color(0xFF6B7280);

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Accessibility Section
          _buildSectionHeader('Aksesibilitas'),
          const SizedBox(height: 12),
          _buildSettingCard(
            context: context,
            icon: Icons.accessibility_new_rounded,
            iconColor: secondaryTeal,
            title: 'Pengaturan Aksesibilitas',
            subtitle: 'Ukuran teks & kecerahan layar',
            onTap: () => _showAccessibilitySettings(context),
          ),
          const SizedBox(height: 24),

          // General Section
          _buildSectionHeader('Umum'),
          const SizedBox(height: 12),

          // Terms & Conditions
          _buildSettingCard(
            context: context,
            icon: Icons.description_rounded,
            iconColor: primaryBlue,
            title: 'Terms & Conditions',
            subtitle: 'Syarat dan ketentuan penggunaan',
            onTap: () => _showTermsDialog(context),
          ),
          const SizedBox(height: 12),

          // Rate App
          _buildSettingCard(
            context: context,
            icon: Icons.star_rounded,
            iconColor: accentAmber,
            title: 'Rate App',
            subtitle: 'Berikan penilaian aplikasi',
            onTap: () => _showRateDialog(context),
          ),
          const SizedBox(height: 12),

          // Edit Profile
          _buildSettingCard(
            context: context,
            icon: Icons.person_rounded,
            iconColor: secondaryTeal,
            title: 'Profile',
            subtitle: 'Informasi profil Anda',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: neutralGray,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: primaryDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: neutralGray,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAccessibilitySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AccessibilitySettingsSheet(),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.description_rounded,
                        color: primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: primaryDarkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermsSection(
                        '1. Penerimaan Ketentuan',
                        'Dengan mengakses dan menggunakan Aplikasi Materi Kurikulum ("Aplikasi"), Anda setuju untuk terikat oleh syarat dan ketentuan ini.',
                      ),
                      _buildTermsSection(
                        '2. Penggunaan Aplikasi',
                        'Aplikasi ini disediakan untuk tujuan pendidikan dan pembelajaran. Anda tidak diperbolehkan untuk menggunakan aplikasi untuk tujuan yang melanggar hukum.',
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Terakhir diperbarui: 16 November 2024',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRateDialog(BuildContext context) {
    int selectedRating = 0;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: accentAmber.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: accentAmber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: accentAmber,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Rate Aplikasi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: primaryDarkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            size: 60,
                            color: errorRed,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Bagaimana pengalaman Anda?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: primaryDarkBlue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Berikan rating untuk membantu kami meningkatkan aplikasi',
                            style: TextStyle(
                              fontSize: 14,
                              color: neutralGray,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            children: List.generate(5, (index) {
                              final starNumber = index + 1;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedRating = starNumber;
                                  });
                                },
                                child: Icon(
                                  starNumber <= selectedRating
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  color: accentAmber,
                                  size: 40,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          if (selectedRating > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: accentAmber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getRatingText(selectedRating),
                                style: const TextStyle(
                                  color: accentAmber,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: selectedRating > 0
                                ? () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Terima kasih atas rating $selectedRating bintang! ⭐',
                                        ),
                                        backgroundColor: successGreen,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentAmber,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                            child: const Text(
                              'Kirim Rating',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: primaryDarkBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: neutralGray,
              height: 1.6,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Sangat Buruk 😞';
      case 2:
        return 'Kurang Baik 😕';
      case 3:
        return 'Cukup Baik 😐';
      case 4:
        return 'Baik 😊';
      case 5:
        return 'Sangat Baik! 🎉';
      default:
        return '';
    }
  }
}

// Accessibility Settings Bottom Sheet
class AccessibilitySettingsSheet extends StatefulWidget {
  const AccessibilitySettingsSheet({super.key});

  @override
  State<AccessibilitySettingsSheet> createState() =>
      _AccessibilitySettingsSheetState();
}

class _AccessibilitySettingsSheetState
    extends State<AccessibilitySettingsSheet> {
  @override
  Widget build(BuildContext context) {
    final accessibilityProvider = Provider.of<AccessibilityProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: secondaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.accessibility_new_rounded,
                      color: secondaryTeal,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Pengaturan Aksesibilitas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: primaryDarkBlue,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: neutralGray,
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text Size Section
                    _buildSectionTitle('Ukuran Teks'),
                    const SizedBox(height: 12),
                    _buildTextSizeOptions(accessibilityProvider),
                    const SizedBox(height: 8),
                    _buildTextPreview(accessibilityProvider),
                    const SizedBox(height: 24),

                    // Brightness Section
                    _buildSectionTitle('Kecerahan Aplikasi'),
                    const SizedBox(height: 12),
                    _buildBrightnessSlider(accessibilityProvider),
                    const SizedBox(height: 24),

                    // Haptic Feedback Section
                    _buildSectionTitle('Getaran (Haptic Feedback)'),
                    const SizedBox(height: 12),
                    _buildHapticToggle(accessibilityProvider),
                    const SizedBox(height: 24),

                    // Reset Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await accessibilityProvider.resetToDefaults();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Pengaturan dikembalikan ke default'),
                                backgroundColor: successGreen,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.restore_rounded),
                        label: const Text('Reset ke Default'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          foregroundColor: primaryBlue,
                          side: BorderSide(color: primaryBlue.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primaryDarkBlue,
      ),
    );
  }

  Widget _buildTextSizeOptions(AccessibilityProvider provider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AccessibilityProvider.textScalePresets.entries.map((entry) {
        final isSelected = provider.textScaleFactor == entry.value;
        return ChoiceChip(
          label: Text(entry.key),
          selected: isSelected,
          onSelected: (selected) async {
            if (selected) {
              await provider.setTextScale(entry.value);
              if (provider.hapticEnabled) {
                HapticFeedback.selectionClick();
              }
            }
          },
          selectedColor: secondaryTeal,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : neutralGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextPreview(AccessibilityProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Contoh teks dengan ukuran yang dipilih',
        style: TextStyle(
          fontSize: 16 * provider.textScaleFactor,
          color: primaryDarkBlue,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBrightnessSlider(AccessibilityProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.brightness_low_rounded, color: neutralGray),
              Expanded(
                child: Slider(
                  value: provider.appBrightness,
                  onChanged: (value) async {
                    await provider.setBrightness(value);
                  },
                  onChangeEnd: (value) {
                    if (provider.hapticEnabled) {
                      HapticFeedback.mediumImpact();
                    }
                  },
                  activeColor: secondaryTeal,
                  inactiveColor: Colors.grey.shade300,
                ),
              ),
              const Icon(Icons.brightness_high_rounded, color: neutralGray),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getBrightnessLabel(provider.appBrightness),
            style: TextStyle(
              fontSize: 13,
              color: neutralGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHapticToggle(AccessibilityProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.vibration_rounded,
            color: provider.hapticEnabled ? secondaryTeal : neutralGray,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aktifkan Getaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Getaran saat interaksi dengan aplikasi',
                  style: TextStyle(
                    fontSize: 12,
                    color: neutralGray,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: provider.hapticEnabled,
            onChanged: (value) async {
              await provider.setHapticEnabled(value);
              if (value) {
                HapticFeedback.heavyImpact();
              }
            },
            activeColor: secondaryTeal,
          ),
        ],
      ),
    );
  }

  String _getBrightnessLabel(double brightness) {
    if (brightness < 0.3) return 'Sangat Gelap';
    if (brightness < 0.45) return 'Gelap';
    if (brightness < 0.55) return 'Normal';
    if (brightness < 0.7) return 'Terang';
    return 'Sangat Terang';
  }
}
