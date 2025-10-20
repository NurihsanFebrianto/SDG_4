import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/friend.dart';
import '../providers/friends_provider.dart';

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
        title: const Text('Profil Teman'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(context),
            const SizedBox(height: 32),

            // Profile Details
            _buildProfileDetails(),
            const SizedBox(height: 24),

            // Action Buttons - Beda untuk Added vs Suggested Friends
            _buildActionButtons(context, friendsProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: CachedNetworkImageProvider(friend.picture),
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 16),
        Text(
          friend.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          friend.email,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          friend.location,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isAddedFriend ? Colors.green.shade100 : Colors.blue.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isAddedFriend ? 'Teman' : 'Pengguna Terdaftar',
            style: TextStyle(
              color:
                  isAddedFriend ? Colors.green.shade800 : Colors.blue.shade800,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetails() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailItem(
              icon: Icons.phone,
              title: 'Telepon',
              value: friend.phone,
            ),
            const Divider(),
            _buildDetailItem(
              icon: Icons.location_on,
              title: 'Lokasi',
              value: friend.location,
            ),
            const Divider(),
            _buildDetailItem(
              icon: Icons.calendar_today,
              title: 'Bergabung',
              value: _formatDate(friend.registeredDate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, FriendsProvider provider) {
    return isAddedFriend
        ? _buildAddedFriendActions(context, provider)
        : _buildSuggestedFriendActions(context, provider);
  }

  Widget _buildAddedFriendActions(
      BuildContext context, FriendsProvider provider) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.person_remove, size: 18),
            label: const Text('Hapus Teman'),
            onPressed: () {
              _showRemoveFriendDialog(context, provider);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red.shade300),
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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.person_add, size: 18),
            label: const Text('Tambah Teman'),
            onPressed: () {
              _addFriend(context, provider);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
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
        content: Text('${friend.name} berhasil ditambahkan sebagai teman'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _showRemoveFriendDialog(BuildContext context, FriendsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Teman'),
        content: Text('Hapus ${friend.name} dari daftar teman?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.removeFriend(friend.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${friend.name} dihapus dari teman'),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.pop(context); // Kembali ke previous screen
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
    return '${date.day}/${date.month}/${date.year}';
  }
}
