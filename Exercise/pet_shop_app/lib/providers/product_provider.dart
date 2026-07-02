import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _items = List.from(MockData.products);

  List<Product> get items => [..._items];

  String _searchQuery = '';
  String _sortOrder = 'Ascending'; // or 'Descending'
  String _selectedCategory = 'All';

  List<Product> get filteredAndSortedItems {
    List<Product> result = _items.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    if (_sortOrder == 'Ascending') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else {
      result.sort((a, b) => b.price.compareTo(a.price));
    }

    return result;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOrder(String order) {
    _sortOrder = order;
    notifyListeners();
  }
  
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  String get sortOrder => _sortOrder;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final cats = _items.map((e) => e.category).toSet().toList();
    if (!cats.contains('All')) cats.insert(0, 'All');
    return cats;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
