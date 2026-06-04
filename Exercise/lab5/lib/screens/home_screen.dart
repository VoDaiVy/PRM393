import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  String searchQuery = "";
  String selectedGenre = "All";

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<String> genres = {
      for (final movie in movies) ...movie.genres,
    }.toList()
      ..sort();

    final List<String> filterOptions = [
      "All",
      ...genres,
    ];

    final List<Movie> filteredMovies = movies.where((movie) {
      final bool matchesSearch = movie.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final bool matchesGenre =
          selectedGenre == "All" || movie.genres.contains(selectedGenre);

      return matchesSearch && matchesGenre;
    }).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B0E1A),
              Color(0xFF111A2E),
              Color(0xFF0B0E1A),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Discover",
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Cinematic picks for tonight",
                              style: textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.outline),
                        ),
                        child: const Icon(Icons.person),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search movies, actors, or genres",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
                  child: SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final genre = filterOptions[index];
                        final bool isSelected = genre == selectedGenre;

                        return ChoiceChip(
                          selected: isSelected,
                          label: Text(genre),
                          onSelected: (_) {
                            setState(() {
                              selectedGenre = genre;
                            });
                          },
                          selectedColor: colors.primary,
                          backgroundColor: colors.surface,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? colors.onPrimary
                                : colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(color: colors.outline),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemCount: filterOptions.length,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 10, bottom: 18),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final movie = filteredMovies[index];

                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(
                                movie: movie,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: filteredMovies.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}