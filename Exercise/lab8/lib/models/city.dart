class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;

  City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      country: json['country'] as String? ?? 'Unknown',
    );
  }
}
