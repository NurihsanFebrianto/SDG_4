import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/modul_provider.dart';
import '../models/modul.dart';
import 'bab_list_screen.dart';

// Academic Color Scheme (sesuai dengan HomeScreen)
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

class ModulListScreen extends StatelessWidget {
  const ModulListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final daftarModul = context.watch<ModulProvider>().modul;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Katalog Modul Akademik',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: daftarModul.isEmpty
          ? _buildLoadingState()
          : Container(
              color: Colors.grey.shade50,
              child: ListView.separated(
                itemCount: daftarModul.length,
                padding: const EdgeInsets.all(20),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final Modul modul = daftarModul[index];
                  return _AcademicModulCard(modul: modul);
                },
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              size: 48,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Memuat Modul...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryDarkBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Menyiapkan materi pembelajaran',
            style: TextStyle(
              color: neutralGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _AcademicModulCard extends StatelessWidget {
  final Modul modul;

  const _AcademicModulCard({required this.modul});

  // Method untuk mendapatkan info modul dengan tema akademik
  _AcademicModulInfo _getModulInfo(String modulNama) {
    switch (modulNama) {
      case 'Bahasa Indonesia':
        return _AcademicModulInfo(
          Icons.language_rounded,
          primaryBlue,
          'Kuasa Kata, Rajai Logika',
        );
      case 'Bahasa Inggris':
        return _AcademicModulInfo(
          Icons.translate_rounded,
          secondaryTeal,
          'Global Communication Mastery',
        );
      case 'Biologi':
        return _AcademicModulInfo(
          Icons.psychology_rounded,
          successGreen,
          'Explore Life Mysteries',
        );
      case 'Matematika':
        return _AcademicModulInfo(
          Icons.calculate_rounded,
          accentOrange,
          'Logic & Problem Solving',
        );
      case 'Fisika':
        return _AcademicModulInfo(
          Icons.science_rounded,
          secondaryCyan,
          'Laws of Universe',
        );
      case 'Kimia':
        return _AcademicModulInfo(
          Icons.emoji_objects_rounded,
          Colors.purple,
          'Atomic World Explorer',
        );
      default:
        return _AcademicModulInfo(
          Icons.menu_book_rounded,
          neutralGray,
          'Academic Excellence',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final modulInfo = _getModulInfo(modul.nama);

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      shadowColor: modulInfo.color.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BabListScreen(modul: modul),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  modulInfo.color.withOpacity(0.05),
                  modulInfo.color.withOpacity(0.02),
                ],
              ),
            ),
            child: Row(
              children: [
                // Icon Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: modulInfo.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    modulInfo.icon,
                    color: modulInfo.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Content Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modul.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: primaryDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        modulInfo.subtitle,
                        style: TextStyle(
                          color: neutralGray,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: modulInfo.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${modul.babList.length} BAB',
                              style: TextStyle(
                                color: modulInfo.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: TextStyle(
                              color: neutralGray.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${modul.babList.length} Materi',
                            style: TextStyle(
                              color: neutralGray,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trailing Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: modulInfo.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: modulInfo.color,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper class untuk menyimpan info modul dengan tema akademik
class _AcademicModulInfo {
  final IconData icon;
  final Color color;
  final String subtitle;

  _AcademicModulInfo(this.icon, this.color, this.subtitle);
}
