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

  factory Modul.fromMap(Map<String, dynamic> map) {
    return Modul(
      id: map['id'] as String,
      nama: map['nama'] as String,
      babList: (map['babList'] as List).map((e) => Bab.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'babList': babList.map((b) => b.toMap()).toList(),
    };
  }
}
