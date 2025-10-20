class Friend {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String picture;
  final String location;
  final DateTime registeredDate;

  Friend({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.picture,
    required this.location,
    required this.registeredDate,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    final nameJson = json['name'];
    final locationJson = json['location'];
    final registeredJson = json['registered'];

    return Friend(
      id: json['login']['uuid'],
      name: '${nameJson['first']} ${nameJson['last']}',
      email: json['email'],
      phone: json['phone'],
      picture: json['picture']['large'],
      location: '${locationJson['city']}, ${locationJson['country']}',
      registeredDate: DateTime.parse(registeredJson['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'picture': picture,
      'location': location,
      'registeredDate': registeredDate.toIso8601String(),
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      picture: map['picture'],
      location: map['location'],
      registeredDate: DateTime.parse(map['registeredDate']),
    );
  }
}
