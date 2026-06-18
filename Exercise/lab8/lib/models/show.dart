class Show {
  final int id;
  final String name;
  final List<String> genres;
  final double rating;
  final String? imageUrl;
  final String summary;
  final String premiered;

  Show({
    required this.id,
    required this.name,
    required this.genres,
    required this.rating,
    this.imageUrl,
    required this.summary,
    required this.premiered,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      rating: (json['rating']?['average'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image']?['medium'] as String?,
      summary: json['summary'] as String? ?? 'No summary available.',
      premiered: json['premiered'] as String? ?? 'Unknown',
    );
  }
}
