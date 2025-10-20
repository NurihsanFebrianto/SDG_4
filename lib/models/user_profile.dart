class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String website;
  final String city;
  final String company;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.city,
    required this.company,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      city: json['address']?['city'] ?? '',
      company: json['company']?['name'] ?? '',
    );
  }
}
