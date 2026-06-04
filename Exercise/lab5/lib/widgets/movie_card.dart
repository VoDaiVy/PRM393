import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 22,
        ),
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [

            // BACKGROUND POSTER
            Hero(
              tag: movie.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.network(
                  movie.posterUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // DARK GRADIENT
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
            ),

            // CONTENT
            Positioned(
              left: 22,
              right: 22,
              bottom: 22,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // RATING BADGE
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: colors.onSecondary,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          movie.rating.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // TITLE
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  // YEAR + DURATION
                  Row(
                    children: [
                      Text(
                        movie.year
                            .toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const CircleAvatar(
                        radius: 2,
                        backgroundColor:
                            Colors.white70,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "${movie.duration.inHours}h ${movie.duration.inMinutes.remainder(60)}m",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // GENRES
                  Wrap(
                    spacing: 8,
                    children: movie.genres
                        .take(3)
                        .map(
                          (genre) =>
                              Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  12,
                              vertical:
                                  6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              genre,
                              style:
                                  const TextStyle(
                                color: Colors
                                    .white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}