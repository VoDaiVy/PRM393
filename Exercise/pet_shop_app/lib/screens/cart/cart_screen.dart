import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items.values.toList();
    final subtotal = cartProvider.totalAmount;
    final tax = subtotal * 0.10;
    final total = subtotal + tax;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F5F0),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shopping Cart',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A2E)),
            ),
            Text(
              '${cartProvider.itemCount} item${cartProvider.itemCount == 1 ? '' : 's'}',
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some pet goodies to get started!',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) {
                      final ci = cartItems[i];
                      return Dismissible(
                        key: ValueKey(ci.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.shade400,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline_rounded,
                                  color: Colors.white, size: 28),
                              SizedBox(height: 4),
                              Text('Remove',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        onDismissed: (_) =>
                            cartProvider.removeItem(ci.product.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Product image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: ci.product.imageUrl != null &&
                                        ci.product.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        ci.product.imageUrl!,
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          width: 72,
                                          height: 72,
                                          color: const Color(0xFFF0EBE3),
                                          child: const Icon(Icons.pets,
                                              color: Color(0xFFD4B896)),
                                        ),
                                      )
                                    : Container(
                                        width: 72,
                                        height: 72,
                                        color: const Color(0xFFF0EBE3),
                                        child: const Icon(Icons.pets,
                                            color: Color(0xFFD4B896)),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ci.product.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1A1A2E),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${ci.product.price.toStringAsFixed(2)} each',
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _qtyButton(
                                          icon: Icons.remove,
                                          onTap: () => cartProvider
                                              .removeSingleItem(ci.product.id),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Text(
                                            '${ci.quantity}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF1A1A2E),
                                            ),
                                          ),
                                        ),
                                        _qtyButton(
                                          icon: Icons.add,
                                          onTap: () =>
                                              cartProvider.addItem(ci.product),
                                          filled: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Total price
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  '\$${ci.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFFF5722),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Order Summary ─────────────────────────────────────
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _summaryRow('Tax (10%)', '\$${tax.toStringAsFixed(2)}'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFF5722),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF8A65), Color(0xFFFF5722)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFFFF8A65).withValues(alpha: 0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              final currentUser = authProvider.currentUser;
                              Provider.of<OrderProvider>(context, listen: false)
                                  .addOrder(
                                cartItems,
                                cartProvider.totalAmount,
                                currentUser?.fullName ?? 'Unknown',
                                currentUser?.email ?? 'Unknown',
                              );
                              cartProvider.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      '✅ Order placed successfully!'),
                                  backgroundColor:
                                      Colors.green.shade600,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                              context.go('/products');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.shopping_bag_outlined,
                                color: Colors.white),
                            label: const Text('Checkout Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
        Text(value,
            style: const TextStyle(
                color: Color(0xFF1A1A2E),
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _qtyButton(
      {required IconData icon, required VoidCallback onTap, bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFFFF8A65) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 16,
            color: filled ? Colors.white : const Color(0xFF1A1A2E)),
      ),
    );
  }
}
