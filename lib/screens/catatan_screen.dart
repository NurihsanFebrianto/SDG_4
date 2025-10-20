import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';
import '../models/catatan.dart';
import 'tambah_catatan_screen.dart';
import 'edit_catatan_screen.dart';

class CatatanScreen extends StatefulWidget {
  const CatatanScreen({super.key});

  @override
  State<CatatanScreen> createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen> {
  @override
  void initState() {
    super.initState();
    // Load data ketika screen pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatatanProvider>().refreshCatatan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final catatanProv = context.watch<CatatanProvider>();
    final daftarCatatan = catatanProv.daftarCatatan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Saya'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              catatanProv.refreshCatatan();
            },
          ),
        ],
      ),
      body: daftarCatatan.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () => catatanProv.refreshCatatan(),
              child: ListView.separated(
                itemCount: daftarCatatan.length,
                padding: const EdgeInsets.symmetric(vertical: 16),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, index) {
                  final catatan = daftarCatatan[index];
                  return _CatatanCard(catatan: catatan);
                },
              ),
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
          ).then((_) {
            // Refresh data setelah kembali dari tambah catatan
            catatanProv.refreshCatatan();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Catatan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + untuk membuat catatan pertama',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class _CatatanCard extends StatelessWidget {
  final Catatan catatan;

  const _CatatanCard({required this.catatan});

  @override
  Widget build(BuildContext context) {
    final catatanProv = Provider.of<CatatanProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          catatan.isi,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (catatan.modulId != null || catatan.babId != null)
              Text(
                '${catatan.modulId ?? "Global"} • ${catatan.babId ?? "Global"}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 4),
            Text(
              'Dibuat: ${_formatDate(catatan.createdAt)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCatatanScreen(catatan: catatan),
                ),
              );
            } else if (value == 'delete') {
              _showDeleteDialog(context, catatan, catatanProv);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Text('Hapus'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditCatatanScreen(catatan: catatan),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, Catatan catatan, CatatanProvider catatanProv) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              catatanProv.hapusCatatan(catatan.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catatan berhasil dihapus'),
                  backgroundColor: Colors.green,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
