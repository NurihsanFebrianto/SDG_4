class ProfileModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String jenisKelamin;
  final String asalSekolah;
  final String alamat;
  final String imagePath;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.jenisKelamin,
    required this.asalSekolah,
    required this.alamat,
    required this.imagePath,
  });

  factory ProfileModel.fromMap(String uid, Map<String, dynamic> data) {
    return ProfileModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      jenisKelamin: data['jenisKelamin'] ?? '',
      asalSekolah: data['asalSekolah'] ?? '',
      alamat: data['alamat'] ?? '',
      imagePath: data['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'jenisKelamin': jenisKelamin,
      'asalSekolah': asalSekolah,
      'alamat': alamat,
      'imagePath': imagePath,
    };
  }

  ProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? jenisKelamin,
    String? asalSekolah,
    String? alamat,
    String? imagePath,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      asalSekolah: asalSekolah ?? this.asalSekolah,
      alamat: alamat ?? this.alamat,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
