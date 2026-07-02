import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total, String userName, String userEmail) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
        userName: userName,
        userEmail: userEmail,
      ),
    );
    notifyListeners();
  }
}
