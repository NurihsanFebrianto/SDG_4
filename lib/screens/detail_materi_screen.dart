import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';
import '../providers/user_provider.dart';
import 'tambah_catatan_screen.dart';

class DetailMateriScreen extends StatefulWidget {
  final String modulId;
  final String modulNama;
  final String babId;
  final String babNama;
  final String isiMateri;

  const DetailMateriScreen({
    super.key,
    required this.modulId,
    required this.modulNama,
    required this.babId,
    required this.babNama,
    required this.isiMateri,
  });

  @override
  State<DetailMateriScreen> createState() => _DetailMateriScreenState();
}

class _DetailMateriScreenState extends State<DetailMateriScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Simpan materi terakhir dibuka
    final userProv = context.read<UserProvider>();
    userProv.setMateriTerakhir(
      modulId: widget.modulId,
      modulNama: widget.modulNama,
      babId: widget.babId,
      babNama: widget.babNama,
    );

    // Restore scroll offset kalau ada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final offset = userProv.data?.lastScrollOffset;
      if (offset != null) {
        _scrollController.jumpTo(offset);
      }
    });
  }

  @override
  void dispose() {
    // Simpan posisi scroll terakhir
    final userProv = context.read<UserProvider>();
    userProv.setLastScrollOffset(
      modulId: widget.modulId,
      babId: widget.babId,
      offset: _scrollController.offset,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catProv = context.watch<CatatanProvider>();
    final catatanList = catProv.catatanUntuk(widget.modulId, widget.babId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.babNama),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isiMateri,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Side Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (catatanList.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Belum ada side note untuk bab ini.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: catatanList.length,
                itemBuilder: (ctx, i) {
                  final c = catatanList[i];
                  return Card(
                    child: ListTile(
                      title: Text(c.isi),
                      onTap: () {
                        _editSideNote(context, c.id, c.isi);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          catProv.hapusCatatan(c.id);
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pos = _scrollController.offset;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TambahCatatanScreen(
                modulId: widget.modulId,
                modulNama: widget.modulNama,
                babId: widget.babId,
                babNama: widget.babNama,
              ),
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(pos);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editSideNote(BuildContext context, String id, String isiAwal) {
    final TextEditingController _controller =
        TextEditingController(text: isiAwal);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Edit Catatan'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Ubah catatan...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final isiBaru = _controller.text.trim();
                if (isiBaru.isNotEmpty) {
                  Provider.of<CatatanProvider>(context, listen: false)
                      .updateCatatan(id, isiBaru);
                }
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
