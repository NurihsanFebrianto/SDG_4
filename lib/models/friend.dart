// friend.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String picture;
  final DateTime registeredDate;
  final DateTime? addedAt; // ✅ Nullable karena bisa belum ada saat create

  Friend({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.picture,
    required this.registeredDate,
    this.addedAt, // ✅ Optional
  });

  // =====================================================
  // ✅ CONVERT FRIEND TO JSON UNTUK FIRESTORE
  // =====================================================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'picture': picture,
      'registeredDate': registeredDate.toIso8601String(),
      'addedAt': FieldValue.serverTimestamp(), // ✅ Auto-generate timestamp
    };
  }

  // =====================================================
  // ✅ CREATE FRIEND FROM FIRESTORE DATA
  // =====================================================
  factory Friend.fromJson(Map<String, dynamic> json) {
    // ✅ Handle Timestamp dari Firestore
    DateTime? addedAtDateTime;
    if (json['addedAt'] != null) {
      if (json['addedAt'] is Timestamp) {
        addedAtDateTime = (json['addedAt'] as Timestamp).toDate();
      } else if (json['addedAt'] is String) {
        addedAtDateTime = DateTime.parse(json['addedAt']);
      }
    }

    return Friend(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      picture: json['picture'] ?? '',
      registeredDate: json['registeredDate'] != null
          ? DateTime.parse(json['registeredDate'])
          : DateTime.now(),
      addedAt: addedAtDateTime, // ✅ Bisa null jika belum ada
    );
  }

  // =====================================================
  // ✅ CREATE FRIEND FROM FIRESTORE DOCUMENT SNAPSHOT
  // =====================================================
  factory Friend.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Friend.fromJson(data);
  }

  // =====================================================
  // ✅ COPY WITH (untuk update data)
  // =====================================================
  Friend copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? picture,
    DateTime? registeredDate,
    DateTime? addedAt,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      picture: picture ?? this.picture,
      registeredDate: registeredDate ?? this.registeredDate,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // =====================================================
  // ✅ HELPER: Format tanggal ditambahkan
  // =====================================================
  String getFormattedAddedDate() {
    if (addedAt == null) return 'Baru saja';

    final now = DateTime.now();
    final difference = now.difference(addedAt!);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Baru saja';
        }
        return '${difference.inMinutes} menit yang lalu';
      }
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
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
      return '${addedAt!.day} ${months[addedAt!.month - 1]} ${addedAt!.year}';
    }
  }

  // =====================================================
  // ✅ HELPER: Check if recently added (dalam 24 jam)
  // =====================================================
  bool get isRecentlyAdded {
    if (addedAt == null) return true;
    final difference = DateTime.now().difference(addedAt!);
    return difference.inHours < 24;
  }

  @override
  String toString() {
    return 'Friend(id: $id, name: $name, email: $email, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Friend && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
