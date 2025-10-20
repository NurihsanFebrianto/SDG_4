class UserData {
  String? nama;
  int? umur;
  String? jenisKelamin;
  String? email;

  String? modulTerakhirId;
  String? babTerakhirId;
  String? modulTerakhirNama;
  String? babTerakhirNama;
  double? lastScrollOffset;

  UserData({
    this.nama,
    this.umur,
    this.jenisKelamin,
    this.email,
    this.modulTerakhirId,
    this.babTerakhirId,
    this.modulTerakhirNama,
    this.babTerakhirNama,
    this.lastScrollOffset,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'umur': umur,
      'jenisKelamin': jenisKelamin,
      'email': email,
      'modulTerakhirId': modulTerakhirId,
      'babTerakhirId': babTerakhirId,
      'modulTerakhirNama': modulTerakhirNama,
      'babTerakhirNama': babTerakhirNama,
      'lastScrollOffset': lastScrollOffset,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      nama: map['nama'] as String?,
      umur: map['umur'] is int
          ? map['umur'] as int
          : int.tryParse(map['umur']?.toString() ?? ''),
      jenisKelamin: map['jenisKelamin'] as String?,
      email: map['email'] as String?,
      modulTerakhirId: map['modulTerakhirId'] as String?,
      babTerakhirId: map['babTerakhirId'] as String?,
      modulTerakhirNama: map['modulTerakhirNama'] as String?,
      babTerakhirNama: map['babTerakhirNama'] as String?,
      lastScrollOffset: map['lastScrollOffset'] != null
          ? double.tryParse(map['lastScrollOffset'].toString())
          : null,
    );
  }
}
