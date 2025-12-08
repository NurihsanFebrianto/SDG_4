// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/profile_provider.dart';

// // Asumsi Anda memiliki model seperti ini
// // import '../models/user_model.dart';

// class ProfileDetailScreen extends StatelessWidget {
//   const ProfileDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Mendefinisikan warna biru yang akan digunakan secara konsisten
//     final Color primaryBlue = Colors.blue.shade700;

//     final profileProvider = context.watch<ProfileProvider>();
//     final user = profileProvider.user;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Profil'),
//         // Menggunakan warna biru yang sudah didefinisikan
//         backgroundColor: primaryBlue,
//         foregroundColor: Colors.white, // Warna untuk title dan ikon (putih)
//         elevation: 1,
//       ),
//       body: user == null
//           // Tampilan saat data masih loading atau tidak ada
//           ? const Center(child: CircularProgressIndicator())
//           : ListView(
//               padding: const EdgeInsets.all(16.0),
//               children: [
//                 _buildProfileHeader(context, user, primaryBlue),
//                 const SizedBox(height: 24),
//                 _buildInfoCard(context, user, primaryBlue),
//               ],
//             ),
//     );
//   }

//   // Widget untuk bagian header profil (Foto, Nama, Email)
//   Widget _buildProfileHeader(BuildContext context, user, Color color) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 50,
//           // Menggunakan warna biru yang sudah didefinisikan dengan opacity
//           backgroundColor: color.withOpacity(0.1),
//           child: Text(
//             user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
//             style: TextStyle(
//               fontSize: 48,
//               fontWeight: FontWeight.bold,
//               // Menggunakan warna biru yang sudah didefinisikan
//               color: color,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           user.name,
//           style: Theme.of(context)
//               .textTheme
//               .headlineSmall
//               ?.copyWith(fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 4),
//         Text(
//           user.email,
//           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                 color: Colors.grey[600],
//               ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   // Widget untuk kartu informasi kontak dan perusahaan
//   Widget _buildInfoCard(BuildContext context, user, Color color) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           _buildInfoTile(
//             context,
//             icon: Icons.phone_outlined,
//             title: 'Telepon',
//             subtitle: user.phone,
//             color: color,
//           ),
//           const Divider(height: 1, indent: 16, endIndent: 16),
//           _buildInfoTile(
//             context,
//             icon: Icons.language_outlined,
//             title: 'Website',
//             subtitle: user.website,
//             color: color,
//           ),
//           const Divider(height: 1, indent: 16, endIndent: 16),
//           _buildInfoTile(
//             context,
//             icon: Icons.location_city_outlined,
//             title: 'Kota',
//             subtitle: user.city,
//             color: color,
//           ),
//           const Divider(height: 1, indent: 16, endIndent: 16),
//           _buildInfoTile(
//             context,
//             icon: Icons.business_outlined,
//             title: 'Perusahaan',
//             subtitle: user.company,
//             color: color,
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget template untuk setiap baris informasi
//   Widget _buildInfoTile(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color, // Menambahkan parameter warna
//     bool isLast = false,
//   }) {
//     // Mengatur padding agar sudut tile mengikuti bentuk Card
//     final verticalPadding = isLast ? 16.0 : 8.0;

//     return ListTile(
//       contentPadding: EdgeInsets.fromLTRB(16, verticalPadding, 16, 8),
//       leading: Icon(icon, color: color),
//       title: Text(
//         title,
//         style:
//             TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
//       ),
//       subtitle: Text(
//         subtitle,
//         style: Theme.of(context).textTheme.bodyLarge,
//       ),
//     );
//   }
// }
