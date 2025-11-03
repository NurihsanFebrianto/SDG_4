import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_provider.dart';
import '../models/catatan.dart';
import 'tambah_catatan_screen.dart';
import 'edit_catatan_screen.dart';

// Academic Color Constants
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

class CatatanScreen extends StatefulWidget {
  const CatatanScreen({super.key});

  @override
  State<CatatanScreen> createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatatanProvider>().refreshCatatan();
    });
  }

  Map<String, List<Catatan>> _groupCatatanByModul(List<Catatan> catatan) {
    final grouped = <String, List<Catatan>>{};
    for (var cat in catatan) {
      final key = cat.modulId ?? 'Global';
      grouped.putIfAbsent(key, () => []).add(cat);
    }
    return grouped;
  }

  Color _getModulColor(String modulId) {
    final colors = {
      'bindo': primaryBlue,
      'inggris': secondaryCyan,
      'biologi': successGreen,
      'matematika': accentAmber,
      'fisika': primaryLightBlue,
      'kimia': secondaryTeal,
      'sejarah': errorRed,
      'geografi': warningYellow,
      'Global': neutralGray,
    };
    return colors[modulId.toLowerCase()] ?? secondaryBlue;
  }

  // Fungsi untuk konversi modul ID ke nama yang lebih user friendly
  String _getModulDisplayName(String modulId) {
    final modulNames = {
      'bindo': 'Bahasa Indonesia',
      'inggris': 'Bahasa Inggris',
      'biologi': 'Biologi',
      'matematika': 'Matematika',
      'fisika': 'Fisika',
      'kimia': 'Kimia',
      'sejarah': 'Sejarah',
      'geografi': 'Geografi',
      'Global': 'Catatan Umum',
    };
    return modulNames[modulId] ?? modulId;
  }

  // Fungsi untuk konversi bab ID ke format yang lebih user friendly
  String _getBabDisplayName(String? babId) {
    if (babId == null || babId.isEmpty) return '';

    // Jika babId sudah berupa "Bab 1" atau format yang bagus, return langsung
    if (babId.toLowerCase().startsWith('bab')) {
      return babId;
    }

    // Jika babId berupa angka saja, tambahkan "Bab"
    if (RegExp(r'^\d+$').hasMatch(babId)) {
      return 'Bab $babId';
    }

    // Jika babId berupa "bab1", "bab2", dll
    if (babId.toLowerCase().startsWith('bab')) {
      final number = babId.substring(3);
      if (RegExp(r'^\d+$').hasMatch(number)) {
        return 'Bab $number';
      }
    }

    // Default: return babId as is
    return babId;
  }

  @override
  Widget build(BuildContext context) {
    final catatanProv = context.watch<CatatanProvider>();
    final daftarCatatan = catatanProv.daftarCatatan;
    final groupedCatatan = _groupCatatanByModul(daftarCatatan);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: daftarCatatan.isEmpty
          ? _buildAcademicEmptyState()
          : RefreshIndicator(
              color: primaryBlue,
              backgroundColor: Colors.white,
              onRefresh: () => catatanProv.refreshCatatan(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: groupedCatatan.keys.length,
                itemBuilder: (ctx, index) {
                  final modulId = groupedCatatan.keys.elementAt(index);
                  final catatanList = groupedCatatan[modulId]!;
                  return _AcademicModulGroup(
                    modulId: modulId,
                    catatan: catatanList,
                    color: _getModulColor(modulId),
                    displayName: _getModulDisplayName(modulId),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
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
          ).then((_) => catatanProv.refreshCatatan());
        },
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.note_add_rounded, size: 22),
        label: const Text(
          'Catatan Baru',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAcademicEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryBlue.withOpacity(0.1),
                    secondaryCyan.withOpacity(0.1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.note_alt_outlined,
                size: 72,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Belum Ada Catatan Akademik',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: primaryDarkBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Mulai buat catatan untuk materi pelajaranmu\ndan tingkatkan produktivitas belajar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: neutralGray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Buat Catatan Pertama',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademicModulGroup extends StatelessWidget {
  final String modulId;
  final List<Catatan> catatan;
  final Color color;
  final String displayName;

  const _AcademicModulGroup({
    required this.modulId,
    required this.catatan,
    required this.color,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, Color.lerp(color, primaryDarkBlue, 0.3)!],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.library_books_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${catatan.length} catatan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  catatan.length.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...catatan.map((cat) => _AcademicCatatanCard(
              catatan: cat,
              color: color,
              getBabDisplayName: _getBabDisplayName,
            )),
        const SizedBox(height: 8),
      ],
    );
  }

  // Fungsi untuk konversi bab ID ke format yang lebih user friendly
  String _getBabDisplayName(String? babId) {
    if (babId == null || babId.isEmpty) return '';

    // Jika babId sudah berupa "Bab 1" atau format yang bagus, return langsung
    if (babId.toLowerCase().startsWith('bab')) {
      return babId;
    }

    // Jika babId berupa angka saja, tambahkan "Bab"
    if (RegExp(r'^\d+$').hasMatch(babId)) {
      return 'Bab $babId';
    }

    // Jika babId berupa "bab1", "bab2", dll
    if (babId.toLowerCase().startsWith('bab')) {
      final number = babId.substring(3);
      if (RegExp(r'^\d+$').hasMatch(number)) {
        return 'Bab $number';
      }
    }

    // Default: return babId as is
    return babId;
  }
}

class _AcademicCatatanCard extends StatelessWidget {
  final Catatan catatan;
  final Color color;
  final String Function(String?) getBabDisplayName;

  const _AcademicCatatanCard({
    required this.catatan,
    required this.color,
    required this.getBabDisplayName,
  });

  @override
  Widget build(BuildContext context) {
    final catatanProv = Provider.of<CatatanProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditCatatanScreen(catatan: catatan),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            catatan.isi,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (catatan.babId != null &&
                              catatan.babId!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: color.withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_stories_rounded,
                                      size: 14, color: color),
                                  const SizedBox(width: 6),
                                  Text(
                                    getBabDisplayName(catatan.babId),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    _buildAcademicPopupMenu(context, catatan, catatanProv),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: neutralGray.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.access_time_rounded,
                          size: 12, color: neutralGray),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatAcademicDate(catatan.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: neutralGray,
                        fontWeight: FontWeight.w500,
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

  Widget _buildAcademicPopupMenu(
      BuildContext context, Catatan catatan, CatatanProvider catatanProv) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.more_horiz_rounded, color: neutralGray, size: 18),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditCatatanScreen(catatan: catatan),
            ),
          );
        } else if (value == 'delete') {
          _showAcademicDeleteDialog(context, catatan, catatanProv);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit_rounded, size: 16, color: primaryBlue),
              ),
              const SizedBox(width: 12),
              const Text(
                'Edit Catatan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: errorRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_rounded, size: 16, color: errorRed),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hapus Catatan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAcademicDeleteDialog(
      BuildContext context, Catatan catatan, CatatanProvider catatanProv) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: errorRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.warning_amber_rounded,
                    size: 32, color: errorRed),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hapus Catatan?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Catatan yang dihapus tidak dapat dikembalikan. Yakin ingin melanjutkan?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: neutralGray,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        catatanProv.hapusCatatan(catatan.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: Colors.white),
                                SizedBox(width: 8),
                                Text('Catatan berhasil dihapus'),
                              ],
                            ),
                            backgroundColor: successGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: errorRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Hapus'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAcademicDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} menit lalu';
      }
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
