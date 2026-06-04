class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final int year;
  final Duration duration;
  final List<String> trailers;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.year,
    required this.duration,
    required this.trailers,
  });
}