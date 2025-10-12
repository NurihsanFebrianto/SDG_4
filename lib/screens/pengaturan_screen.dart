import 'package:flutter/material.dart';
import 'profile_screen.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms & Conditions'),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Terms & Conditions'),
                content: const Text(
                  'Isi Terms & Conditions bisa kamu ubah nanti sesuai kebutuhan.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.star_rate),
          title: const Text('Rate App'),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Rate Aplikasi'),
                content: const Text(
                  'Fitur rate bisa diarahkan ke Play Store / dialog rating nanti.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Oke'),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Edit Profile'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
        ),
      ],
    );
  }
}
