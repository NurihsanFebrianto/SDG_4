class UserData {
  String nama;
  int? umur;
  String? jenisKelamin;

  String? modulTerakhirId;
  String? babTerakhirId;
  String? modulTerakhirNama;
  String? babTerakhirNama;
  double? lastScrollOffset;

  UserData({
    required this.nama,
    this.umur,
    this.jenisKelamin,
    this.modulTerakhirId,
    this.babTerakhirId,
    this.modulTerakhirNama,
    this.babTerakhirNama,
    this.lastScrollOffset,
  });

  // Convert to Map (kalau disimpan ke local storage / database)
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'umur': umur,
      'jenisKelamin': jenisKelamin,
      'modulTerakhirId': modulTerakhirId,
      'babTerakhirId': babTerakhirId,
      'modulTerakhirNama': modulTerakhirNama,
      'babTerakhirNama': babTerakhirNama,
      'lastScrollOffset': lastScrollOffset,
    };
  }

  // Convert dari Map ke objek
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      nama: map['nama'],
      umur: map['umur'],
      jenisKelamin: map['jenisKelamin'],
      modulTerakhirId: map['modulTerakhirId'],
      babTerakhirId: map['babTerakhirId'],
      modulTerakhirNama: map['modulTerakhirNama'],
      babTerakhirNama: map['babTerakhirNama'],
      lastScrollOffset: map['lastScrollOffset']?.toDouble(),
    );
  }
}
