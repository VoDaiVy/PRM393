import 'package:flutter/material.dart';
import '../models/show.dart';
import '../services/favorites_manager.dart';

class MovieDetailScreen extends StatefulWidget {
  final Show show;

  const MovieDetailScreen({super.key, required this.show});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoritesManager.isFavorite(widget.show.id);
  }

  String _stripHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B), // Nền đen tuyền rạp phim
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFE11D48),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.show.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 4))],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.show.imageUrl != null
                      ? Image.network(
                          widget.show.imageUrl!.replaceAll('medium', 'original'),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.network(widget.show.imageUrl!, fit: BoxFit.cover),
                        )
                      : Container(color: const Color(0xFF27272A)),
                  
                  // Lớp phủ đen để làm chữ dễ đọc hơn
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, const Color(0xFF09090B).withOpacity(0.9)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 36),
                          const SizedBox(width: 8),
                          Text('${widget.show.rating}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
                        ],
                      ),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: const Color(0xFF27272A), // Nút tối màu
                        elevation: 4,
                        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: const Color(0xFFE11D48)),
                        onPressed: () {
                          setState(() { 
                            isFavorite = !isFavorite; 
                            FavoritesManager.toggleFavorite(widget.show);
                          });
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFavorite ? 'Saved to Favorites ❤️' : 'Removed from Favorites'),
                              backgroundColor: const Color(0xFFE11D48),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tính năng Đánh giá sao tương tác (Interactive Rating)
                  const Text('Rate this show', style: TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const InteractiveStarRating(),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white60, size: 20),
                      const SizedBox(width: 8),
                      Text('Premiered: ${widget.show.premiered}', style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.show.genres.map((genre) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF27272A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(genre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                    )).toList(),
                  ),
                  const SizedBox(height: 32),
                  
                  const Text('Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  Text(
                    _stripHtml(widget.show.summary),
                    style: const TextStyle(fontSize: 16, height: 1.7, color: Colors.white70),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget đánh giá sao tương tác
class InteractiveStarRating extends StatefulWidget {
  const InteractiveStarRating({super.key});

  @override
  State<InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<InteractiveStarRating> {
  int _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = index + 1;
            });
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You rated this show $_currentRating stars! ⭐'),
                backgroundColor: Colors.black87,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              index < _currentRating ? Icons.star : Icons.star_border,
              color: index < _currentRating ? Colors.amber : Colors.white38,
              size: 36,
            ),
          ),
        );
      }),
    );
  }
}
