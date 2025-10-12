class Bab {
  final String id;
  final String judul;
  final String konten;

  Bab({
    required this.id,
    required this.judul,
    required this.konten,
  });

  factory Bab.fromMap(Map<String, dynamic> m) => Bab(
        id: m['id'] as String,
        judul: m['judul'] as String,
        konten: m['konten'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'judul': judul,
        'konten': konten,
      };
}
