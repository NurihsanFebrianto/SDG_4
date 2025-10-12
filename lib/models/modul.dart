import 'bab.dart';

class Modul {
  final String id;
  final String nama;
  final List<Bab> babList;

  Modul({
    required this.id,
    required this.nama,
    required this.babList,
  });

  factory Modul.fromMap(Map<String, dynamic> m) => Modul(
        id: m['id'] as String,
        nama: m['nama'] as String,
        babList: (m['babList'] as List).map((e) => Bab.fromMap(e)).toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nama': nama,
        'babList': babList.map((b) => b.toMap()).toList(),
      };
}
