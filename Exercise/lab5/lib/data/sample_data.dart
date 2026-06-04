import '../models/movie.dart';

List<Movie> movies = [
  Movie(
    id: 1,
    title: "Avengers: Endgame",
    posterUrl:
        "https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg",
    overview:
        "After the devastating events of Infinity War, the Avengers assemble once more to reverse Thanos' actions and restore balance to the universe.",
    genres: [
      "Action",
      "Adventure",
      "Sci-Fi",
    ],
    rating: 8.9,
    year: 2019,
    duration: const Duration(
      hours: 3,
      minutes: 1,
    ),
    trailers: [
      "Official Trailer",
      "Final Trailer",
      "Behind the Scenes",
    ],
  ),

  Movie(
    id: 2,
    title: "The Batman",
    posterUrl:
        "https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg",
    overview:
        "Batman ventures into Gotham City's underworld when a sadistic killer leaves behind cryptic clues.",
    genres: [
      "Action",
      "Crime",
      "Drama",
    ],
    rating: 8.1,
    year: 2022,
    duration: const Duration(
      hours: 2,
      minutes: 56,
    ),
    trailers: [
      "Official Trailer",
      "Batmobile Scene",
      "Action Clip",
    ],
  ),

  Movie(
    id: 3,
    title: "Interstellar",
    posterUrl:
        "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
    overview:
        "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
    genres: [
      "Sci-Fi",
      "Drama",
      "Adventure",
    ],
    rating: 8.6,
    year: 2014,
    duration: const Duration(
      hours: 2,
      minutes: 49,
    ),
    trailers: [
      "Official Trailer",
      "Docking Scene",
      "Space Exploration",
    ],
  ),
];