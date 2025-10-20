import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';

class TambahCatatanScreen extends StatefulWidget {
  final String modulId;
  final String modulNama;
  final String babId;
  final String babNama;

  const TambahCatatanScreen({
    super.key,
    required this.modulId,
    required this.modulNama,
    required this.babId,
    required this.babNama,
  });

  @override
  State<TambahCatatanScreen> createState() => _TambahCatatanScreenState();
}

class _TambahCatatanScreenState extends State<TambahCatatanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFromHome = widget.modulId.isEmpty && widget.babId.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isFromHome) ...[
                Text('Modul: ${widget.modulNama}'),
                const SizedBox(height: 4),
                Text(
                  'Bab: ${widget.babNama}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _controller,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Tulis catatan kamu...',
                  border: OutlineInputBorder(),
                  labelText: 'Isi Catatan',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanCatatan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Simpan Catatan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _simpanCatatan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanProvider =
        Provider.of<CatatanProvider>(context, listen: false);

    catatanProvider.tambahCatatan(
      _controller.text.trim(),
      modulId: widget.modulId.isEmpty ? null : widget.modulId,
      babId: widget.babId.isEmpty ? null : widget.babId,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil disimpan'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}
