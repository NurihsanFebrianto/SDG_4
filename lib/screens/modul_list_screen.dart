import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/modul_provider.dart';
import '../models/modul.dart';
import 'bab_list_screen.dart';

class ModulListScreen extends StatelessWidget {
  const ModulListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final daftarModul = context.watch<ModulProvider>().modul;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Modul'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: daftarModul.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: daftarModul.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final Modul modul = daftarModul[index];
                return _ModulCard(modul: modul);
              },
            ),
    );
  }
}

class _ModulCard extends StatelessWidget {
  final Modul modul;

  const _ModulCard({required this.modul});

  // Method untuk mendapatkan info modul
  _ModulInfo _getModulInfo(String modulNama) {
    switch (modulNama) {
      case 'Bahasa Indonesia':
        return _ModulInfo(Icons.language, Colors.blue);
      case 'Bahasa Inggris':
        return _ModulInfo(Icons.translate, Colors.green);
      case 'Biologi':
        return _ModulInfo(Icons.psychology, Colors.purple);
      default:
        return _ModulInfo(Icons.menu_book, Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final modulInfo = _getModulInfo(modul.nama);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: modulInfo.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(modulInfo.icon, color: modulInfo.color),
        ),
        title: Text(
          modul.nama,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${modul.babList.length} bab',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: modulInfo.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BabListScreen(modul: modul),
            ),
          );
        },
      ),
    );
  }
}

// Helper class untuk menyimpan info modul
class _ModulInfo {
  final IconData icon;
  final Color color;

  _ModulInfo(this.icon, this.color);
}
