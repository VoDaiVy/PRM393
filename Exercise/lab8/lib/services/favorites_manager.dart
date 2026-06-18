import '../models/show.dart';

class FavoritesManager {
  static final List<Show> favoriteShows = [];
  
  static bool isFavorite(int id) {
    return favoriteShows.any((show) => show.id == id);
  }

  static void toggleFavorite(Show show) {
    if (isFavorite(show.id)) {
      favoriteShows.removeWhere((s) => s.id == show.id);
    } else {
      favoriteShows.add(show);
    }
  }
}
