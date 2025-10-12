class Catatan {
  final String id;
  String isi;
  final String? modulId;
  final String? babId;
  final DateTime createdAt;

  Catatan({
    required this.id,
    required this.isi,
    this.modulId,
    this.babId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    // ← BAGIAN 1: SERIALIZE DATA
    return {
      // Convert object Catatan jadi Map
      'id': id, // buat disimpan ke SharedPreferences
      'isi': isi, // dalam format JSON
      'modulId': modulId,
      'babId': babId,
      'createdAt':
          createdAt.toIso8601String(), // DateTime harus diconvert ke String
    };
  }

  factory Catatan.fromMap(Map<String, dynamic> map) {
    // ← BAGIAN 2: DESERIALIZE DATA
    return Catatan(
      // Convert Map dari SharedPreferences
      id: map['id'], // kembali jadi object Catatan
      isi: map['isi'],
      modulId: map['modulId'],
      babId: map['babId'],
      createdAt:
          DateTime.parse(map['createdAt']), // String dikembalikan ke DateTime
    );
  }
}
