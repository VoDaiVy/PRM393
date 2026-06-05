import 'package:flutter/material.dart';

class CoffeeShopOrderingApp extends StatefulWidget {
  const CoffeeShopOrderingApp({super.key});

  @override
  State<CoffeeShopOrderingApp> createState() => _CoffeeShopOrderingAppState();
}

class _CoffeeShopOrderingAppState extends State<CoffeeShopOrderingApp> {
  int _coffeeQuantity = 0;
  int _milkTeaQuantity = 0;
  int _cakeQuantity = 0;

  final double _coffeePrice = 2.0;
  final double _milkTeaPrice = 3.5;
  final double _cakePrice = 2.5;

  double get _totalPrice =>
      (_coffeeQuantity * _coffeePrice) +
      (_milkTeaQuantity * _milkTeaPrice) +
      (_cakeQuantity * _cakePrice);

  Widget _buildMenuItem({
    required String name,
    required double price,
    required int quantity,
    required IconData icon,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Colors.brown),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('\$${price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onDecrement,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Colors.brown,
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.brown,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shop Ordering'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildMenuItem(
                  name: 'Coffee',
                  price: _coffeePrice,
                  quantity: _coffeeQuantity,
                  icon: Icons.coffee,
                  onIncrement: () => setState(() => _coffeeQuantity++),
                  onDecrement: () => setState(() {
                    if (_coffeeQuantity > 0) _coffeeQuantity--;
                  }),
                ),
                _buildMenuItem(
                  name: 'Milk Tea',
                  price: _milkTeaPrice,
                  quantity: _milkTeaQuantity,
                  icon: Icons.local_drink,
                  onIncrement: () => setState(() => _milkTeaQuantity++),
                  onDecrement: () => setState(() {
                    if (_milkTeaQuantity > 0) _milkTeaQuantity--;
                  }),
                ),
                _buildMenuItem(
                  name: 'Cake',
                  price: _cakePrice,
                  quantity: _cakeQuantity,
                  icon: Icons.cake,
                  onIncrement: () => setState(() => _cakeQuantity++),
                  onDecrement: () => setState(() {
                    if (_cakeQuantity > 0) _cakeQuantity--;
                  }),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                ),
              ],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _totalPrice > 0
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Order placed! Total: \$${_totalPrice.toStringAsFixed(2)}'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              setState(() {
                                _coffeeQuantity = 0;
                                _milkTeaQuantity = 0;
                                _cakeQuantity = 0;
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Place Order',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
