import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';
import 'tambah_catatan_screen.dart';
import 'edit_catatan_screen.dart';

class CatatanScreen extends StatelessWidget {
  const CatatanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catatanProv = context.watch<CatatanProvider>();
    final daftar = catatanProv.daftarCatatan;

    return Scaffold(
      body: daftar.isEmpty
          ? const Center(child: Text('Belum ada catatan'))
          : ListView.builder(
              itemCount: daftar.length,
              itemBuilder: (ctx, i) {
                final c = daftar[i];
                return ListTile(
                  title: Text(
                    c.isi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: (c.modulId != null || c.babId != null)
                      ? Text(
                          'Modul: ${c.modulId ?? "-"} | Bab: ${c.babId ?? "-"}',
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      catatanProv.hapusCatatan(c.id);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCatatanScreen(catatan: c),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahCatatanScreen(
                modulId: '',
                modulNama: '',
                babId: '',
                babNama: '',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
