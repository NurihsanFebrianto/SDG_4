import 'package:aplikasi_materi_kurikulum/providers/progress_provider.dart';
import 'package:aplikasi_materi_kurikulum/providers/user_provider.dart';
import 'package:aplikasi_materi_kurikulum/screens/progress_list_Screen.dart';
import 'package:aplikasi_materi_kurikulum/services/auth_preferens.dart';
import 'package:aplikasi_materi_kurikulum/screens/friends_list_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/modul_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aplikasi_materi_kurikulum/screens/catatan_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/pengaturan_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/profile_screen.dart';
import 'package:aplikasi_materi_kurikulum/providers/friends_provider.dart';
import 'package:aplikasi_materi_kurikulum/models/friend.dart';

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
        return 'Catatan Saya';
      case 1:
        return 'Beranda';
      case 2:
        return 'Pengaturan';
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 1,
        actions: [
          IconButton(
            tooltip: 'Profil',
            icon: const Icon(Icons.person_outline),
            onPressed: () async {
              final isLoggedIn = await AuthPreferens().isLoggedIn();
              if (!isLoggedIn) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            activeIcon: Icon(Icons.note_alt),
            label: 'Catatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
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
      context.read<ProgressProvider>().getProgress(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(context),
          const SizedBox(height: 28),
          _buildQuickActions(context),
          const SizedBox(height: 28),
          Consumer<ProgressProvider>(
            builder: (context, progressProvider, _) {
              if (progressProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (progressProvider.error != null) {
                return Text(
                  'Gagal memuat progres: ${progressProvider.error}',
                  style: const TextStyle(color: Colors.red),
                );
              }

              final progress = progressProvider.progress;
              if (progress == null) {
                return const Text('Belum ada data progres.');
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Header dengan tombol "Lihat Semua"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progres Belajar 📈',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () async {
                            final provider = context.read<ProgressProvider>();
                            await provider.getAllProgress("1");

                            if (provider.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Gagal memuat data: ${provider.error}')),
                              );
                              return;
                            }

                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProgressListScreen(
                                      progressList: provider.allProgress),
                                ),
                              );
                            }
                          },
                          child: const Text('Lihat Semua'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildProgressItem(
                            'Hari Ini', '${progress.dailyCompleted} tugas'),
                        _buildProgressItem(
                            'Minggu Ini', '${progress.weeklyCompleted} tugas'),
                        _buildProgressItem('Streak', '${progress.streak} hari'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                        value: progress.lessonProgress / 100),
                    const SizedBox(height: 10),
                    Text(
                      'Modul: ${progress.currentModule} • Pelajaran: ${progress.currentLesson}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildFriendsSection(context, friendsProvider),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final quotes = [
      "Belajar hari ini untuk kesuksesan esok hari! 📚",
      "Ilmu adalah harta yang tak pernah habis. Teruslah belajar! 💡",
      "Setiap bab yang kamu baca membawamu lebih dekat ke impianmu. 🌟",
      "Konsistensi adalah kunci menguasai ilmu. Tetap semangat! 🔑",
      "Membaca satu bab sehari menjadikanmu ahli seiring waktu. ⏳"
    ];
    final randomQuote = quotes[DateTime.now().millisecond % quotes.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang! 👋',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            randomQuote,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // --- Quick Actions (Modul & Teman)
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akses Cepat',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.menu_book,
                title: 'Modul',
                subtitle: '3 materi belajar',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ModulListScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.people,
                title: 'Teman',
                subtitle: 'Lihat teman',
                color: Colors.purple,
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

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color color,
      required VoidCallback onTap}) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 10),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  // --- Friends Section
  Widget _buildFriendsSection(BuildContext context, FriendsProvider provider) {
    final friendsCount = provider.addedFriends.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Teman Belajar 👥',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FriendsListScreen()),
                );
              },
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (friendsCount > 0)
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: friendsCount > 5 ? 5 : friendsCount,
              itemBuilder: (context, index) {
                final friend = provider.addedFriends[index];
                return _buildFriendItem(friend);
              },
            ),
          )
        else
          _buildEmptyFriendsState(context),
      ],
    );
  }

  Widget _buildFriendItem(Friend friend) {
    return Container(
      width: 75,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: CachedNetworkImageProvider(friend.picture),
          ),
          const SizedBox(height: 6),
          Text(
            friend.name.split(' ').first,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFriendsState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 10),
          Text('Belum ada teman',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 6),
          Text(
            'Tambahkan teman untuk berbagi materi belajar',
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FriendsListScreen()),
              );
            },
            child: const Text('Cari Teman'),
          ),
        ],
      ),
    );
  }
}
