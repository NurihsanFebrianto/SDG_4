import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';
import '../models/catatan.dart';

class EditCatatanScreen extends StatefulWidget {
  final Catatan catatan;

  const EditCatatanScreen({super.key, required this.catatan});

  @override
  State<EditCatatanScreen> createState() => _EditCatatanScreenState();
}

class _EditCatatanScreenState extends State<EditCatatanScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _isiBaru;

  @override
  void initState() {
    super.initState();
    _isiBaru = widget.catatan.isi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                initialValue: _isiBaru,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Isi catatan wajib'
                    : null,
                onSaved: (v) => _isiBaru = v!.trim(),
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
                      .updateCatatan(widget.catatan.id, _isiBaru);

                  Navigator.pop(context);
                },
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
