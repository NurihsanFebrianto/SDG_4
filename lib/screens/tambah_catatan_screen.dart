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
  String _isi = '';

  @override
  Widget build(BuildContext context) {
    final isFromHome = widget.modulId.isEmpty && widget.babId.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 12),
            ],
            Form(
              key: _formKey,
              child: TextFormField(
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Tulis catatan kamu...',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Catatan wajib diisi'
                    : null,
                onSaved: (v) => _isi = v!.trim(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();

                  Provider.of<CatatanProvider>(context, listen: false)
                      .tambahCatatan(
                    _isi,
                    modulId: widget.modulId.isEmpty ? null : widget.modulId,
                    babId: widget.babId.isEmpty ? null : widget.babId,
                  );

                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
