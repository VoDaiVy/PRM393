import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, Product> _items = {};

  Map<String, Product> get items => {..._items};

  int get itemCount => _items.length;

  bool isWishlisted(String productId) => _items.containsKey(productId);

  void toggleWishlist(Product product) {
    if (_items.containsKey(product.id)) {
      _items.remove(product.id);
    } else {
      _items[product.id] = product;
    }
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
