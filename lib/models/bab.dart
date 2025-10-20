class Bab {
  final String id;
  final String judul;
  final String konten;

  Bab({
    required this.id,
    required this.judul,
    required this.konten,
  });

  factory Bab.fromMap(Map<String, dynamic> map) {
    return Bab(
      id: map['id'] as String,
      judul: map['judul'] as String,
      konten: map['konten'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'konten': konten,
    };
  }
}
