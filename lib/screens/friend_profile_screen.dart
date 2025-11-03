import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/friend.dart';
import '../providers/friends_provider.dart';

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

class FriendProfileScreen extends StatelessWidget {
  final Friend friend;
  final bool isAddedFriend;

  const FriendProfileScreen({
    super.key,
    required this.friend,
    required this.isAddedFriend,
  });

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Akademik',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            _buildAcademicProfileHeader(context),
            const SizedBox(height: 32),

            // Profile Details
            _buildAcademicProfileDetails(),
            const SizedBox(height: 24),

            // Action Buttons
            _buildAcademicActionButtons(context, friendsProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: [
          // Profile Picture with Border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundImage: CachedNetworkImageProvider(friend.picture),
              backgroundColor: Colors.grey[300],
              onBackgroundImageError: (exception, stackTrace) => const Icon(
                Icons.person_rounded,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            friend.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            friend.email,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_rounded,
                  size: 14, color: Colors.white.withOpacity(0.8)),
              const SizedBox(width: 4),
              Text(
                friend.location,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              isAddedFriend ? 'Teman Belajar' : 'Calon Teman Belajar',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicProfileDetails() {
    return Container(
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
        children: [
          // Section Header
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Informasi Kontak',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryDarkBlue,
                  ),
                ),
              ],
            ),
          ),

          // Details Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildAcademicDetailItem(
                  icon: Icons.phone_rounded,
                  title: 'Telepon',
                  value: friend.phone,
                  color: secondaryCyan,
                ),
                const SizedBox(height: 16),
                _buildAcademicDetailItem(
                  icon: Icons.location_city_rounded,
                  title: 'Lokasi',
                  value: friend.location,
                  color: secondaryTeal,
                ),
                const SizedBox(height: 16),
                _buildAcademicDetailItem(
                  icon: Icons.calendar_month_rounded,
                  title: 'Bergabung',
                  value: _formatAcademicDate(friend.registeredDate),
                  color: accentAmber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: neutralGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicActionButtons(
      BuildContext context, FriendsProvider provider) {
    return isAddedFriend
        ? _buildAddedFriendActions(context, provider)
        : _buildSuggestedFriendActions(context, provider);
  }

  Widget _buildAddedFriendActions(
      BuildContext context, FriendsProvider provider) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: errorRed.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.person_remove_rounded, size: 20),
            label: const Text(
              'Hapus dari Teman Belajar',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              _showRemoveFriendDialog(context, provider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: errorRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedFriendActions(
      BuildContext context, FriendsProvider provider) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: successGreen.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
            label: const Text(
              'Tambah ke Teman Belajar',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              _addFriend(context, provider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: successGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  void _addFriend(BuildContext context, FriendsProvider provider) {
    provider.addFriend(friend);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '${friend.name} berhasil ditambahkan sebagai teman belajar',
                style: TextStyle(fontWeight: FontWeight.w600),
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
      ),
    );
    Navigator.pop(context);
  }

  void _showRemoveFriendDialog(BuildContext context, FriendsProvider provider) {
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
                child:
                    Icon(Icons.person_off_rounded, size: 32, color: errorRed),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hapus Teman Belajar?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apakah Anda yakin ingin menghapus ${friend.name} dari daftar teman belajar?',
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                        provider.removeFriend(friend.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                    '${friend.name} dihapus dari teman belajar'),
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
                        Navigator.pop(context);
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
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
