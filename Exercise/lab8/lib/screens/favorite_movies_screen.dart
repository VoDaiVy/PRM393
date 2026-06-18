import 'package:flutter/material.dart';
import '../services/favorites_manager.dart';
import 'movie_screen.dart';
import 'movie_detail_screen.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  const FavoriteMoviesScreen({super.key});

  @override
  State<FavoriteMoviesScreen> createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesManager.favoriteShows;
    
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        title: const Text('My Favorites', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.heart_broken, size: 80, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  const Text('No favorites yet.', style: TextStyle(color: Colors.white54, fontSize: 18)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final show = favorites[index];
                return HoverMovieCard(
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(show: show),
                        ),
                      );
                      setState(() {}); // Reload khi back lại để cập nhật danh sách
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
                            show.imageUrl != null
                                ? Image.network(show.imageUrl!, fit: BoxFit.cover)
                                : Container(color: const Color(0xFF27272A), child: const Icon(Icons.movie, size: 50, color: Colors.grey)),
                            Positioned(
                              bottom: 0, left: 0, right: 0, height: 120,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12, left: 12, right: 12,
                              child: Text(
                                show.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800,
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
              },
            ),
    );
  }
}
