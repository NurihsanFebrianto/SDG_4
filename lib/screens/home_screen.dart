import 'package:aplikasi_materi_kurikulum/services/auth_preferens.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_materi_kurikulum/screens/modul_list_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/catatan_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/pengaturan_screen.dart';
import 'package:aplikasi_materi_kurikulum/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 1; // 0 Catatan, 1 Beranda, 2 Pengaturan

  final List<Widget> _pages = [
    const CatatanScreen(),
    const ModulListScreen(),
    const PengaturanScreen(),
  ];

  String get _title {
    switch (_index) {
      case 0:
        return 'Catatan';
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
        title: Text(_title),
        actions: [
          IconButton(
            tooltip: 'Profil',
            icon: const Icon(Icons.person),
            onPressed: () async {
              // Cek status login langsung lewat SharedPreferences/AuthService
              final isLoggedIn = await AuthPreferens().isLoggedIn();
              if (!isLoggedIn) return; // kalau tidak login, tidak buka profile

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Catatan'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
