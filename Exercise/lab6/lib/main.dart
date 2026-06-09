import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 6 - Responsive UI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(
          0xFF0F0F13,
        ), // Deep modern dark background
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF), // Modern purple accent
          surface: Color(0xFF1C1C24), // Slightly lighter surface for cards
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Clean font
      ),
      home: const GenreScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Constant list of sample movies
final List<Movie> allMovies = [
  const Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Sci-Fi', 'Action'],
    rating: 8.8,
    posterUrl:
        'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
  ),
  const Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    rating: 9.0,
    posterUrl:
        'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
  ),
  const Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama'],
    rating: 8.6,
    posterUrl:
        'https://image.tmdb.org/t/p/w500/gEU2QlsUUQZnK2sW1AItBntB6B7.jpg',
  ),
  const Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Sci-Fi'],
    rating: 8.4,
    posterUrl:
        'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
  ),
  const Movie(
    title: 'Joker',
    year: 2019,
    genres: ['Drama', 'Thriller'],
    rating: 8.4,
    posterUrl:
        'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
  ),
  const Movie(
    title: 'Parasite',
    year: 2019,
    genres: ['Comedy', 'Drama'],
    rating: 8.6,
    posterUrl:
        'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
  ),
  const Movie(
    title: 'Spider-Man: No Way Home',
    year: 2021,
    genres: ['Action', 'Adventure'],
    rating: 8.0,
    posterUrl:
        'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1R80vEMqm08Ofm.jpg',
  ),
  const Movie(
    title: 'The Matrix',
    year: 1999,
    genres: ['Sci-Fi', 'Action'],
    rating: 8.7,
    posterUrl:
        'https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg',
  ),
];

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = '';
  List<String> selectedGenres = [];
  String selectedSort = 'A-Z';

  final List<String> genres = [
    'Action',
    'Sci-Fi',
    'Drama',
    'Comedy',
    'Thriller',
    'Adventure',
  ];

  final List<String> sortOptions = ['A-Z', 'Z-A', 'Rating', 'Year'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Movie> visibleMovies = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesGenre =
          selectedGenres.isEmpty ||
          movie.genres.any((g) => selectedGenres.contains(g));
      return matchesSearch && matchesGenre;
    }).toList();

    visibleMovies.sort((a, b) {
      if (selectedSort == 'A-Z') {
        return a.title.compareTo(b.title);
      } else if (selectedSort == 'Z-A') {
        return b.title.compareTo(a.title);
      } else if (selectedSort == 'Rating') {
        return b.rating.compareTo(a.rating);
      } else if (selectedSort == 'Year') {
        return b.year.compareTo(a.year);
      }
      return 0;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrWeb = screenWidth >= 800;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text(
                'Find a Movie',
                style: TextStyle(
                  fontSize: isTabletOrWeb ? 40 : 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a movie title or keyword...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF1C1C24), // Modern dark pill
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF6C63FF),
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // Filters Section (Sort & Genres)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sort by',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C24),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSort,
                            dropdownColor: const Color(0xFF1C1C24),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white70,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            items: sortOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedSort = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Genres Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Genres',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          if (selectedGenres.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C63FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${selectedGenres.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (searchQuery.isNotEmpty ||
                          selectedGenres.isNotEmpty ||
                          selectedSort != 'A-Z')
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                              searchQuery = '';
                              selectedGenres.clear();
                              selectedSort = 'A-Z';
                            });
                          },
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: Color(0xFF6C63FF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Genre Chips
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: genres.map((genre) {
                      final isSelected = selectedGenres.contains(genre);
                      return FilterChip(
                        label: Text(
                          genre,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[400],
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedGenres.add(genre);
                            } else {
                              selectedGenres.remove(genre);
                            }
                          });
                        },
                        backgroundColor: const Color(0xFF1C1C24),
                        selectedColor: const Color(
                          0xFF6C63FF,
                        ), // Vibrant selection
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ), // Pill shape chips
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF6C63FF)
                                : Colors.transparent,
                          ),
                        ),
                        showCheckmark: false,
                        elevation: isSelected
                            ? 4
                            : 0, // Slight shadow when selected
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Movie List View
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (visibleMovies.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.movie_filter,
                            size: 64,
                            color: Colors.grey[800],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No movies found.',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (constraints.maxWidth < 800) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: visibleMovies.length,
                      itemBuilder: (context, index) {
                        return ResponsiveMovieCard(movie: visibleMovies[index]);
                      },
                    );
                  } else {
                    return GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: visibleMovies.map((movie) {
                        return ResponsiveMovieCard(movie: movie);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveMovieCard extends StatelessWidget {
  final Movie movie;

  const ResponsiveMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF1C1C24), // Matches surface color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ), // Subtle border
      ),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movie),
            ),
          );
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            double itemWidth = constraints.maxWidth;
            double posterWidth = itemWidth > 350 ? 110 : 90;

            return SizedBox(
              height: 140, // Slightly more compact card height
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster Image
                  Image.network(
                    movie.posterUrl,
                    width: posterWidth,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: posterWidth,
                        height: 140,
                        color: const Color(0xFF2C2C34),
                        child: const Icon(
                          Icons.movie,
                          size: 40,
                          color: Colors.white24,
                        ),
                      );
                    },
                  ),

                  // Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${movie.title} (${movie.year})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            movie.genres.join(', '),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFC312),
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                movie.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Detail Screen
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isFavorite = false;
  int _userRating = 0;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? const Color(0xFFFF5252) : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? 'Added to Favorites ❤️'
                        : 'Removed from Favorites',
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: const Color(0xFF2C2C34),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Poster
            Image.network(
              movie.posterUrl,
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 400,
                  color: const Color(0xFF1C1C24),
                  child: const Icon(
                    Icons.movie,
                    size: 100,
                    color: Colors.white24,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${movie.title} (${movie.year})',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Average Rating
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C24),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFC312),
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${movie.rating} / 10',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Average Score',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Interactive User Rating
                  const Text(
                    'Rate this movie',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        iconSize: 40,
                        padding: const EdgeInsets.only(right: 8),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          index < _userRating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFC312),
                        ),
                        onPressed: () {
                          setState(() {
                            _userRating = index + 1;
                          });

                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'You rated this movie $_userRating stars! 🌟',
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 1),
                              backgroundColor: const Color(0xFF2C2C34),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Genres
                  const Text(
                    'Genres',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: movie.genres.map((g) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C24),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Text(
                          g,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This is a mock description for the movie. In a production application, this information would be retrieved from a backend server or a movie database API along with the poster image and other relevant details.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
