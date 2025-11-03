import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';

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
          'Catatan Akademik Baru',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Module Info Card (jika dari modul tertentu)
                if (!isFromHome) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryBlue, primaryLightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.modulNama,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_stories_rounded,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Bab: ${widget.babNama}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                ],

                // Text Input Section
                Container(
                  padding: const EdgeInsets.all(0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: secondaryTeal.withOpacity(0.08),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: secondaryTeal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.edit_note_rounded,
                                color: secondaryTeal,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Konten Catatan Baru',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: primaryDarkBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Tuliskan catatan akademik Anda',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: neutralGray,
                                    ),
                                  ),
                                ],
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
                          maxLines: 10,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Color(0xFF1E293B),
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Tuliskan catatan akademik Anda di sini...\n\n• Poin penting materi\n• Rumus yang perlu diingat\n• Konsep utama pembelajaran\n• Catatan tambahan...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                              height: 1.4,
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

                // Save Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _simpanCatatan,
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
                        Icon(Icons.save_alt_rounded, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Simpan Catatan Akademik',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tips Section
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: accentAmber.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: accentAmber.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline_rounded,
                          color: accentAmber, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tips: Buat catatan yang jelas dan terstruktur untuk memudahkan belajar ulang',
                          style: TextStyle(
                            fontSize: 13,
                            color: neutralGray,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
            SizedBox(width: 12),
            Text(
              'Catatan akademik berhasil disimpan',
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
