import 'package:flutter/material.dart';
import 'profile_screen.dart';

// Academic Color Scheme
const Color primaryDarkBlue = Color(0xFF0A3D62);
const Color primaryBlue = Color(0xFF1E3A8A);
const Color primaryLightBlue = Color(0xFF0D47A1);
const Color secondaryCyan = Color(0xFF0EA5E9);
const Color secondaryBlue = Color(0xFF0284C7);
const Color secondaryTeal = Color(0xFF14B8A6);
const Color accentAmber = Color(0xFFFBBF24);
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
                        style: TextStyle(
                          fontSize: 13,
                          color: neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
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
              // Header
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
                      child: Icon(
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

              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermsSection(
                        '1. Penerimaan Ketentuan',
                        'Dengan mengakses dan menggunakan Aplikasi Materi Kurikulum ("Aplikasi"), Anda setuju untuk terikat oleh syarat dan ketentuan ini. Jika Anda tidak setuju dengan ketentuan ini, mohon untuk tidak menggunakan aplikasi.',
                      ),
                      _buildTermsSection(
                        '2. Penggunaan Aplikasi',
                        'Aplikasi ini disediakan untuk tujuan pendidikan dan pembelajaran. Anda tidak diperbolehkan untuk:\n\n'
                            '• Menggunakan aplikasi untuk tujuan yang melanggar hukum\n'
                            '• Menyebarkan konten yang mengandung ujaran kebencian, SARA, atau pornografi\n'
                            '• Mencoba mengakses sistem tanpa izin (hacking)\n'
                            '• Menyalahgunakan fitur untuk mengganggu pengguna lain\n'
                            '• Menjual atau mengkomersialkan akses aplikasi',
                      ),
                      _buildTermsSection(
                        '3. Akun Pengguna',
                        'Anda bertanggung jawab untuk menjaga kerahasiaan informasi akun Anda. Setiap aktivitas yang terjadi di bawah akun Anda adalah tanggung jawab Anda. Segera laporkan kepada kami jika Anda mengetahui adanya penggunaan akun Anda tanpa izin.',
                      ),
                      _buildTermsSection(
                        '4. Konten Pengguna',
                        'Anda memiliki hak atas konten yang Anda buat (catatan, komentar, dll). Namun, dengan mengunggah konten, Anda memberikan kami lisensi non-eksklusif untuk menggunakan, menyimpan, dan menampilkan konten tersebut dalam aplikasi. Kami berhak menghapus konten yang melanggar ketentuan atau hukum yang berlaku.',
                      ),
                      _buildTermsSection(
                        '5. Hak Kekayaan Intelektual',
                        'Seluruh materi pembelajaran, desain, logo, dan fitur aplikasi adalah hak milik kami atau pemberi lisensi kami. Anda tidak diperbolehkan menyalin, memodifikasi, atau mendistribusikan konten aplikasi tanpa izin tertulis.',
                      ),
                      _buildTermsSection(
                        '6. Privasi dan Data',
                        'Kami mengumpulkan dan menggunakan data Anda sesuai dengan Kebijakan Privasi kami. Dengan menggunakan aplikasi, Anda menyetujui pengumpulan dan penggunaan data sebagaimana dijelaskan dalam kebijakan tersebut.',
                      ),
                      _buildTermsSection(
                        '7. Perubahan Layanan',
                        'Kami berhak untuk:\n\n'
                            '• Memodifikasi atau menghentikan layanan (sementara atau permanen)\n'
                            '• Mengubah fitur dan fungsi aplikasi\n'
                            '• Memperbarui konten pembelajaran\n'
                            '• Melakukan maintenance tanpa pemberitahuan sebelumnya\n\n'
                            'Kami akan berusaha memberikan pemberitahuan untuk perubahan signifikan.',
                      ),
                      _buildTermsSection(
                        '8. Batasan Tanggung Jawab',
                        'Aplikasi disediakan "sebagaimana adanya" tanpa jaminan apapun, baik tersurat maupun tersirat. Kami tidak bertanggung jawab atas:\n\n'
                            '• Kerugian langsung atau tidak langsung\n'
                            '• Kehilangan data atau kerusakan perangkat\n'
                            '• Gangguan layanan atau kesalahan teknis\n'
                            '• Kesalahan atau ketidakakuratan konten\n'
                            '• Tindakan pihak ketiga',
                      ),
                      _buildTermsSection(
                        '9. Penghentian Akun',
                        'Kami berhak untuk menangguhkan atau menghentikan akun Anda jika:\n\n'
                            '• Anda melanggar ketentuan ini\n'
                            '• Kami mencurigai aktivitas penipuan atau penyalahgunaan\n'
                            '• Diperlukan oleh hukum yang berlaku\n\n'
                            'Anda dapat menghapus akun Anda sendiri melalui pengaturan aplikasi.',
                      ),
                      _buildTermsSection(
                        '10. Hukum yang Berlaku',
                        'Ketentuan ini diatur oleh dan ditafsirkan sesuai dengan hukum Republik Indonesia. Setiap perselisihan akan diselesaikan melalui mediasi terlebih dahulu sebelum dibawa ke pengadilan.',
                      ),
                      _buildTermsSection(
                        '11. Kontak',
                        'Jika Anda memiliki pertanyaan tentang ketentuan ini, hubungi kami di:\n\n'
                            'Email: support@aplikasikurikulum.com\n'
                            'Website: www.aplikasikurikulum.com',
                      ),
                      _buildTermsSection(
                        '12. Perubahan Ketentuan',
                        'Kami dapat memperbarui ketentuan ini dari waktu ke waktu. Perubahan akan berlaku setelah dipublikasikan di aplikasi. Penggunaan aplikasi setelah perubahan berarti Anda menyetujui ketentuan yang telah diperbarui.',
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
                            Icon(
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

              // Footer Button
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
                  // Header
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
                          child: Icon(
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

                  // Content
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
                          Text(
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
                                style: TextStyle(
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

                  // Footer Buttons
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
            style: TextStyle(
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
