import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/modul_provider.dart';
import '../models/modul.dart';
import 'bab_list_screen.dart';

class ModulListScreen extends StatelessWidget {
  const ModulListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final daftar = context.watch<ModulProvider>().modul;

    return ListView.separated(
      itemCount: daftar.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final Modul m = daftar[i];
        return ListTile(
          title: Text(
            m.nama,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BabListScreen(modul: m)),
            );
          },
        );
      },
    );
  }
}
