import 'package:flutter/material.dart';
import '../models/show.dart';
import '../services/api_service.dart';
import 'movie_detail_screen.dart';
import 'favorite_movies_screen.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Show>> _futureShows;
  List<Show> _allShows = [];
  List<Show> _filteredShows = [];
  String _selectedGenre = 'All';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _futureShows = _apiService.fetchShows().then((shows) {
      _allShows = shows;
      _filteredShows = shows;
      return shows;
    });
  }

  void _filterByGenre(String genre) {
    setState(() {
      _selectedGenre = genre;
      if (genre == 'All') {
        _filteredShows = _allShows;
      } else {
        _filteredShows = _allShows.where((show) => show.genres.contains(genre)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B), // Đen tuyền chuẩn Rạp chiếu phim
      appBar: AppBar(
        title: const Text('Cinema Explorer', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Color(0xFFE11D48)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoriteMoviesScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<Show>>(
        future: _futureShows,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE11D48)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (snapshot.hasData) {
            final genresSet = <String>{'All'};
            for (var show in _allShows) {
              genresSet.addAll(show.genres);
            }
            final genresList = genresSet.toList()..sort();
            
            genresList.remove('All');
            genresList.insert(0, 'All');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Horizontal Genre Filter - Dark Mode
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: genresList.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final genre = genresList[index];
                      final isSelected = genre == _selectedGenre;
                      return ActionChip(
                        label: Text(genre),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        backgroundColor: isSelected ? const Color(0xFFE11D48) : const Color(0xFF27272A),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: isSelected ? 4 : 0,
                        shadowColor: const Color(0xFFE11D48).withOpacity(0.4),
                        onPressed: () => _filterByGenre(genre),
                      );
                    },
                  ),
                ),
                // Show Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredShows.length,
                    itemBuilder: (context, index) {
                      final show = _filteredShows[index];
                      return _buildMovieCard(context, show);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, Show show) {
    return HoverMovieCard(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(show: show),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Poster
                show.imageUrl != null
                    ? Image.network(show.imageUrl!, fit: BoxFit.cover)
                    : Container(color: const Color(0xFF27272A), child: const Icon(Icons.movie, size: 50, color: Colors.grey)),
                
                // Dark Gradient Overlay cho phong cách rạp chiếu phim
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                
                // Rating Badge
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.7)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text('${show.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),

                // Title
                Positioned(
                  bottom: 12, left: 12, right: 12,
                  child: Text(
                    show.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HoverMovieCard extends StatefulWidget {
  final Widget child;
  const HoverMovieCard({super.key, required this.child});

  @override
  State<HoverMovieCard> createState() => _HoverMovieCardState();
}

class _HoverMovieCardState extends State<HoverMovieCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(_isHovered ? 1.04 : 1.0),
        child: widget.child,
      ),
    );
  }
}
