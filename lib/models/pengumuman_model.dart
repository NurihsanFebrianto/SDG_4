class Pengumuman {
  final String id;
  final String judul;
  final String deskripsi;
  final String tanggal;

  Pengumuman({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
  });

  factory Pengumuman.fromJson(Map<String, dynamic> json) {
    return Pengumuman(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      tanggal: json['tanggal'] ?? '',
    );
  }
}
