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
  int _currentIndex = 1; // 0 Catatan, 1 Beranda, 2 Pengaturan

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
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
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

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section dengan Quotes Motivasi
          _buildWelcomeSection(context),
          const SizedBox(height: 24),

          // Quick Actions - Hanya Modul & Teman
          _buildQuickActions(context),
          const SizedBox(height: 24),

          // Friends Section di Beranda
          _buildFriendsSection(context, friendsProvider),
          const SizedBox(height: 16), // Extra padding di bawah
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    // Quotes motivasi acak
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
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

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akses Cepat',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        // FIXED: Pakai Row + Expanded untuk responsive
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
            const SizedBox(width: 12),
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

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // PENTING: min size
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsSection(BuildContext context, FriendsProvider provider) {
    final friendsCount = provider.addedFriends.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Teman',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
        const SizedBox(height: 12),
        if (friendsCount > 0) ...[
          SizedBox(
            height: 110, // Dikurangi dari 120 ke 110
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: friendsCount > 5 ? 5 : friendsCount,
              itemBuilder: (context, index) {
                final friend = provider.addedFriends[index];
                return _buildFriendItem(friend, context, provider);
              },
            ),
          ),
        ] else ...[
          _buildEmptyFriendsState(context),
        ],
      ],
    );
  }

  Widget _buildFriendItem(
      Friend friend, BuildContext context, FriendsProvider provider) {
    return GestureDetector(
      onTap: () {
        _showFriendOptions(context, friend, provider);
      },
      child: Container(
        width: 75, // Dikurangi dari 80 ke 75
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28, // Dikurangi dari 30 ke 28
                  backgroundImage: CachedNetworkImageProvider(friend.picture),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              friend.name.split(' ').first,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showFriendOptions(
      BuildContext context, Friend friend, FriendsProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(friend.picture),
                ),
                title: Text(friend.name),
                subtitle: Text(friend.email),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text('Lihat Profil'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to friend profile
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_remove, color: Colors.red),
                title: const Text('Hapus Teman'),
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveFriendDialog(context, friend, provider);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRemoveFriendDialog(
      BuildContext context, Friend friend, FriendsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Teman'),
        content: Text('Hapus ${friend.name} dari daftar teman?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.removeFriend(friend.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${friend.name} dihapus dari teman'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 40,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 10),
          Text(
            'Belum ada teman',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tambahkan teman untuk berbagi materi belajar',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 13,
            ),
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
