import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';
import '../models/catatan.dart';

// Academic Color Constants - PASTIKAN INI DITAMBAHKAN
const Color primaryDarkBlue = Color(0xFF0A3D62);
const Color primaryBlue = Color(0xFF1E3A8A);
const Color primaryLightBlue = Color(0xFF0D47A1);
const Color secondaryCyan = Color(0xFF0EA5E9);
const Color secondaryBlue = Color(0xFF0284C7);
const Color secondaryTeal = Color(0xFF14B8A6);
const Color accentAmber = Color(0xFFFBBF24);
const Color accentOrange = Color(0xFFF59E0B);
const Color successGreen = Color(0xFF10B981);
const Color warningYellow = Color(0xFFF59E0B);
const Color errorRed = Color(0xFFEF4444);
const Color neutralGray = Color(0xFF6B7280);

class EditCatatanScreen extends StatefulWidget {
  final Catatan catatan;

  const EditCatatanScreen({super.key, required this.catatan});

  @override
  State<EditCatatanScreen> createState() => _EditCatatanScreenState();
}

class _EditCatatanScreenState extends State<EditCatatanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.catatan.isi;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryDarkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Catatan Akademik',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: accentAmber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.edit_note_rounded,
                          color: accentAmber,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Catatan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: primaryDarkBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Perbarui konten catatan akademik Anda',
                              style: TextStyle(
                                fontSize: 14,
                                color: neutralGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Text Input Card
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Input Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.05),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.text_fields_rounded,
                              color: primaryBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Konten Catatan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryDarkBlue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Text Field
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _controller,
                          maxLines: 8,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Color(0xFF1E293B),
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Tuliskan pembaruan catatan akademik Anda...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: primaryBlue,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: errorRed,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(18),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Catatan tidak boleh kosong';
                            }
                            if (value.trim().length < 5) {
                              return 'Catatan minimal 5 karakter';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: neutralGray,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Batal',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Save Button
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _simpanPerubahan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Simpan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _simpanPerubahan() {
    if (!_formKey.currentState!.validate()) return;

    final newContent = _controller.text.trim();

    Provider.of<CatatanProvider>(context, listen: false)
        .updateCatatan(widget.catatan.id, newContent);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
            SizedBox(width: 12),
            Text(
              'Catatan berhasil diperbarui',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }
}
