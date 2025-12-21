import 'package:aplikasi_materi_kurikulum/models/pengumuman_model.dart';
import 'package:aplikasi_materi_kurikulum/providers/progress_provider.dart';
import 'package:aplikasi_materi_kurikulum/providers/user_provider.dart';
import 'package:aplikasi_materi_kurikulum/screens/detail_pengumuman_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/pengumuman_list_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/progress_list_Screen.dart';
import 'package:aplikasi_materi_kurikulum/services/auth_preferens.dart';
import 'package:aplikasi_materi_kurikulum/screens/friends_list_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/modul_list_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/pengumuman_list_screen.dart';
import 'package:aplikasi_materi_kurikulum/services/pengumuman_service.dart';
import 'package:aplikasi_materi_kurikulum/widgets/banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aplikasi_materi_kurikulum/screens/catatan_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/pengaturan_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/profile_screen.dart';
import 'package:aplikasi_materi_kurikulum/providers/friends_provider.dart';
import 'package:aplikasi_materi_kurikulum/models/friend.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    const CatatanScreen(),
    const _HomeContent(),
    const PengaturanScreen(),
  ];

  String get _title {
    switch (_currentIndex) {
      case 0:
        return 'Catatan Akademik';
      case 1:
        return 'Dashboard Akademik';
      case 2:
        return 'Pengaturan Sistem';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.school_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),

      // INI BAGIAN PENTING
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: _pages[_currentIndex],
          ),

          // BANNER ADMOB ()
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BannerAdWidget(),
          ),
        ],
      ),

      bottomNavigationBar: _buildAcademicBottomNavigationBar(),
    );
  }

  Widget _buildAcademicBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: primaryBlue,
          unselectedItemColor: neutralGray,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.notes_outlined),
              label: 'Catatan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Pengaturan',
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademicNavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _AcademicNavIcon({
    required this.icon,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: isActive
          ? BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Icon(icon, size: 22),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = "1";
      // context.read<ProgressProvider>().getProgress(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAcademicWelcomeSection(context),
          const SizedBox(height: 32),
          _buildAnnouncementSection(context),
          const SizedBox(height: 32),
          _buildQuickActions(context),
          const SizedBox(height: 32),
          // _buildProgressSection(context),
          // const SizedBox(height: 32),
          _buildFriendsSection(context, friendsProvider),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAcademicWelcomeSection(BuildContext context) {
    final academicQuotes = [
      "Disiplin adalah jembatan antara tujuan dan pencapaian. - Jim Rohn",
      "Pendidikan adalah senjata paling mematikan di dunia, karena dengan itu Anda dapat mengubah dunia. - Nelson Mandela",
      "Investasi dalam pengetahuan selalu membayar bunga terbaik. - Benjamin Franklin",
      "Masa depan adalah milik mereka yang mempersiapkan hari ini. - Malcolm X",
      "Keunggulan bukanlah suatu tindakan, tetapi sebuah kebiasaan. - Aristoteles"
    ];
    final dailyQuote =
        academicQuotes[DateTime.now().millisecond % academicQuotes.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDarkBlue, primaryBlue],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryDarkBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Selamat Datang, Scholar!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            dailyQuote,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: accentAmber,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementSection(BuildContext context) {
    return StreamBuilder<List<Pengumuman>>(
      stream: PengumumanService.streamPengumuman(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1E3A5F),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[300]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Terjadi kesalahan: ${snapshot.error}",
                    style: TextStyle(color: Colors.red[700], fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.notifications_none,
                    color: Colors.grey[400], size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Belum ada pengumuman terbaru.",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final pengumumanList = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pengumuman",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PengumumanListScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2D5F8D),
                  ),
                  child: const Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // LIST HORIZONTAL
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pengumumanList.length,
                itemBuilder: (context, index) {
                  final p = pengumumanList[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPengumumanScreen(pengumuman: p),
                        ),
                      );
                    },
                    child: Container(
                      width: 260,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailPengumumanScreen(pengumuman: p),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon di pojok kiri atas
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF1E3A5F),
                                            Color(0xFF2D5F8D),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.announcement,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Judul
                                Text(
                                  p.judul,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF1E3A5F),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),

                                // Deskripsi
                                Expanded(
                                  child: Text(
                                    p.deskripsi,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ),

                                // Tanggal
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 12,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      p.tanggal,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akses Cepat Akademik',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: primaryDarkBlue,
                fontSize: 18,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAcademicActionCard(
                context,
                icon: Icons.menu_book_rounded,
                title: 'Modul Belajar',
                subtitle: 'Eksplorasi materi',
                color: primaryBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ModulListScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAcademicActionCard(
                context,
                icon: Icons.groups_rounded,
                title: 'Teman',
                subtitle: 'Kolaborasi belajar',
                color: secondaryTeal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const FriendsListScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAcademicActionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color color,
      required VoidCallback onTap}) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      shadowColor: color.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.05),
                  color.withOpacity(0.02),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: neutralGray,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildProgressSection(BuildContext context) {
  //   return Consumer<ProgressProvider>(
  //     builder: (context, progressProvider, _) {
  //       if (progressProvider.isLoading) {
  //         return _buildProgressSkeleton();
  //       }

  //       if (progressProvider.error != null) {
  //         return _buildErrorState(progressProvider.error!);
  //       }

  //       final progress = progressProvider.progress;
  //       if (progress == null) {
  //         return _buildEmptyProgressState();
  //       }

  //       return Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(20),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.1),
  //               blurRadius: 15,
  //               offset: const Offset(0, 5),
  //             ),
  //           ],
  //           border: Border.all(color: Colors.grey.shade100),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.all(6),
  //                       decoration: BoxDecoration(
  //                         color: primaryBlue.withOpacity(0.1),
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       child: const Icon(Icons.timeline_rounded,
  //                           color: primaryBlue, size: 20),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Text(
  //                       'Progress Akademik',
  //                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
  //                             fontWeight: FontWeight.w700,
  //                             color: primaryDarkBlue,
  //                             fontSize: 18,
  //                           ),
  //                     ),
  //                   ],
  //                 ),
  //                 _buildViewAllButton(
  //                   onPressed: () async {
  //                     final provider = context.read<ProgressProvider>();
  //                     await provider.getAllProgress("1");

  //                     if (provider.error != null) {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(
  //                           content:
  //                               Text('Gagal memuat data: ${provider.error}'),
  //                           backgroundColor: errorRed,
  //                         ),
  //                       );
  //                       return;
  //                     }

  //                     if (context.mounted) {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (_) => ProgressListScreen(
  //                               progressList: provider.allProgress),
  //                         ),
  //                       );
  //                     }
  //                   },
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 20),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 _buildAcademicProgressItem(
  //                   'Hari Ini',
  //                   '${progress.dailyCompleted}',
  //                   'tugas',
  //                   secondaryCyan,
  //                 ),
  //                 _buildAcademicProgressItem(
  //                   'Minggu Ini',
  //                   '${progress.weeklyCompleted}',
  //                   'tugas',
  //                   secondaryTeal,
  //                 ),
  //                 _buildAcademicProgressItem(
  //                   'Streak',
  //                   '${progress.streak}',
  //                   'hari',
  //                   accentAmber,
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 20),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       'Progress Modul',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         color: primaryDarkBlue,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                     Text(
  //                       '${progress.lessonProgress}%',
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.w700,
  //                         color: primaryBlue,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Container(
  //                   height: 8,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey.shade200,
  //                     borderRadius: BorderRadius.circular(4),
  //                   ),
  //                   child: Stack(
  //                     children: [
  //                       LayoutBuilder(
  //                         builder: (context, constraints) {
  //                           return AnimatedContainer(
  //                             duration: const Duration(milliseconds: 600),
  //                             width: constraints.maxWidth *
  //                                 (progress.lessonProgress / 100),
  //                             decoration: BoxDecoration(
  //                               gradient: const LinearGradient(
  //                                 colors: [secondaryCyan, secondaryBlue],
  //                               ),
  //                               borderRadius: BorderRadius.circular(4),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Text(
  //                   '${progress.currentModule} • ${progress.currentLesson}',
  //                   style: TextStyle(
  //                     color: neutralGray,
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildAcademicProgressItem(
      String label, String value, String unit, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: neutralGray,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 11,
            color: neutralGray.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildViewAllButton({required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        '',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: secondaryBlue,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildProgressSkeleton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 150,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) => _buildShimmerCircle()),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCircle() {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: errorRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: errorRed.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: errorRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, color: errorRed, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Gagal memuat progress: $error',
              style: TextStyle(color: errorRed, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyProgressState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined, size: 48, color: neutralGray),
          const SizedBox(height: 12),
          Text(
            'Belum Ada Data Progress',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryDarkBlue,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai belajar untuk melihat progress akademik Anda',
            textAlign: TextAlign.center,
            style: TextStyle(color: neutralGray, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsSection(BuildContext context, FriendsProvider provider) {
    final friendsCount = provider.addedFriends.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: secondaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.groups_rounded,
                        color: secondaryTeal, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Teman Belajar',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: primaryDarkBlue,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
              _buildViewAllButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const FriendsListScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (friendsCount > 0)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: friendsCount > 5 ? 5 : friendsCount,
                itemBuilder: (context, index) {
                  final friend = provider.addedFriends[index];
                  return _buildAcademicFriendItem(friend);
                },
              ),
            )
          else
            _buildEmptyAcademicFriendsState(context),
        ],
      ),
    );
  }

  Widget _buildAcademicFriendItem(Friend friend) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: secondaryTeal.withOpacity(0.3), width: 2),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: friend.picture,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: neutralGray),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: neutralGray),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            friend.name.split(' ').first,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primaryDarkBlue,
            ),
          ),
          Text(
            'Scholar',
            style: TextStyle(
              fontSize: 10,
              color: neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAcademicFriendsState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: secondaryTeal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.groups_outlined, size: 32, color: secondaryTeal),
          ),
          const SizedBox(height: 12),
          Text(
            'Teman Anda',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryDarkBlue,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum memiliki teman? Ayo segera cari teman untuk berkolaborasi dan berdiskusi',
            textAlign: TextAlign.center,
            style: TextStyle(color: neutralGray, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FriendsListScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Jelajahi Teman',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
