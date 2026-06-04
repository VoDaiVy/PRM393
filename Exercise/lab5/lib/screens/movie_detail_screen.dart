import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/movie.dart';
import '../widgets/custom_button.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() =>
      _MovieDetailScreenState();
}

class _MovieDetailScreenState
    extends State<MovieDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    const String shareUrl = "https://movie.app/share";

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          // APP BAR POSTER
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: Colors.transparent,

            flexibleSpace:
                FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [

                  Hero(
                    tag: movie.id,
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // GRADIENT
                  Container(
                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        begin:
                            Alignment
                                .topCenter,
                        end:
                            Alignment
                                .bottomCenter,
                        colors: [
                          Colors
                              .transparent,
                          Colors.black
                              .withOpacity(
                                  0.2),
                          const Color(
                              0xFF0B0E1A),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets
                      .all(22),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  // TITLE
                  Text(
                    movie.title,
                    style: textTheme.displaySmall,
                  ),

                  const SizedBox(
                      height: 14),

                  // YEAR + DURATION
                  Row(
                    children: [
                      Text(
                        movie.year
                            .toString(),
                        style: textTheme.bodyMedium,
                      ),

                      const SizedBox(
                          width: 10),

                      const CircleAvatar(
                        radius: 2,
                        backgroundColor:
                            Colors
                                .white70,
                      ),

                      const SizedBox(
                          width: 10),

                      Text(
                        "${movie.duration.inHours}h ${movie.duration.inMinutes.remainder(60)}m",
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 22),

                  Row(
                    children: [
                      CustomButton(
                        label: "Play Trailer",
                        icon: Icons.play_arrow,
                        isPrimary: true,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: colors.surface,
                              content: Text(
                                "Playing ${movie.trailers.first}",
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      CustomButton(
                        label: "Add to List",
                        icon: Icons.bookmark_border,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: colors.surface,
                              content: const Text("Saved to Watchlist"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // INFO CARD
                  Container(
                    padding:
                        const EdgeInsets
                            .all(18),
                    decoration:
                        BoxDecoration(
                      color: colors.surface,
                      borderRadius:
                          BorderRadius
                              .circular(
                                  24),
                      border: Border.all(
                        color: colors.outline,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,
                      children: [

                        // RATING
                        Column(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors
                                  .amber,
                              size: 32,
                            ),
                            const SizedBox(
                                height:
                                    6),
                            Text(
                              movie
                                  .rating
                                  .toString(),
                              style: textTheme.titleMedium,
                            ),
                            const Text("Rating"),
                          ],
                        ),

                        // FAVORITE
                        Column(
                          children: [
                            IconButton(
                              icon:
                                  AnimatedSwitcher(
                                duration:
                                    const Duration(
                                        milliseconds:
                                            300),
                                child:
                                    Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  key: ValueKey(
                                      isFavorite),
                                  color:
                                      Colors.red,
                                  size:
                                      34,
                                ),
                              ),
                              onPressed:
                                  () {
                                setState(
                                    () {
                                  isFavorite =
                                      !isFavorite;
                                });

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  SnackBar(
                                    backgroundColor: colors.surface,
                                    content:
                                        Text(
                                      isFavorite
                                          ? "Added to Favorites ❤️"
                                          : "Removed from Favorites",
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Text(
                                "Favorite"),
                          ],
                        ),

                        // SHARE
                        Column(
                          children: [
                            IconButton(
                              icon:
                                  const Icon(
                                Icons.share,
                                size: 34,
                              ),
                              onPressed:
                                  () async {
                                try {
                                  await Clipboard.setData(
                                    const ClipboardData(text: shareUrl),
                                  );

                                  final ClipboardData? data =
                                      await Clipboard.getData('text/plain');

                                  if (!context.mounted) {
                                    return;
                                  }

                                  final bool isCopied = data?.text == shareUrl;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: colors.surface,
                                      content: Text(
                                        isCopied
                                            ? "Copied link for ${movie.title}"
                                            : "Copy failed. Try again.",
                                      ),
                                    ),
                                  );
                                } catch (_) {
                                  if (!context.mounted) {
                                    return;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: colors.surface,
                                      content: const Text(
                                        "Copy failed. Try again.",
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            const Text(
                                "Share"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 28),

                  // GENRES
                  const Text(
                    "Genres",
                    style:
                        TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                      height: 12),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: movie
                        .genres
                        .map(
                          (genre) =>
                              Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  16,
                              vertical:
                                  10,
                            ),
                            decoration:
                                BoxDecoration(
                              color: colors.primary.withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.circular(
                                      30),
                              border:
                                  Border.all(
                              color: colors.primary,
                              ),
                            ),
                            child:
                                Text(
                              genre,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(
                      height: 30),

                  // OVERVIEW
                  const Text(
                    "Overview",
                    style:
                        TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                      height: 12),

                  Text(
                    movie.overview,
                    style: textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),

                  const SizedBox(
                      height: 30),

                  // TRAILERS
                  const Text(
                    "Trailers",
                    style:
                        TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                      height: 12),

                  Column(
                    children: movie
                        .trailers
                        .map(
                          (trailer) =>
                              Container(
                            margin:
                                const EdgeInsets.only(
                                    bottom:
                                        14),
                            decoration:
                                BoxDecoration(
                              color: colors.surface,
                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                              border: Border.all(
                              color: colors.outline,
                              ),
                            ),
                            child:
                                ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    20,
                                vertical:
                                    8,
                              ),
                              leading:
                                  Container(
                                width:
                                    52,
                                height:
                                    52,
                                decoration:
                                    BoxDecoration(
                                  color: colors.primary,
                                  borderRadius:
                                      BorderRadius.circular(
                                          16),
                                ),
                                child:
                                    const Icon(
                                  Icons
                                      .play_arrow,
                                  color:
                                      Colors
                                          .white,
                                ),
                              ),
                              title:
                                  Text(
                                trailer,
                              ),
                              subtitle:
                                  const Text(
                                "Watch Trailer",
                              ),
                              trailing:
                                  const Icon(
                                Icons
                                    .arrow_forward_ios,
                                size:
                                    18,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(
                      height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}