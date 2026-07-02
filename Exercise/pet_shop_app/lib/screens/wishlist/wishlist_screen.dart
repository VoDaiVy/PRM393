import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import 'package:go_router/go_router.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final products = wishlistProvider.items.values.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F5F0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wishlist',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A2E)),
            ),
            Text(
              '${products.length} saved item${products.length == 1 ? '' : 's'}',
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('❤️', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  const Text(
                    'No favorites yet',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart on any product to save it',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () => context.push('/products/detail/${product.id}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: product.imageUrl != null &&
                                        product.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        product.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (c, e, s) => Container(
                                          color: const Color(0xFFF0EBE3),
                                          child: const Icon(Icons.pets,
                                              color: Color(0xFFD4B896)),
                                        ),
                                      )
                                    : Container(
                                        color: const Color(0xFFF0EBE3),
                                        child: const Icon(Icons.pets,
                                            color: Color(0xFFD4B896)),
                                      ),
                              ),
                              // Remove from wishlist
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: () => wishlistProvider
                                      .removeFromWishlist(product.id),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: Color(0xFFFF5722),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        cartProvider.addItem(product);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                '${product.name} added to cart! 🛒'),
                                            duration:
                                                const Duration(seconds: 1),
                                            behavior:
                                                SnackBarBehavior.floating,
                                            backgroundColor:
                                                const Color(0xFFFF8A65),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            margin: const EdgeInsets.all(16),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF8A65),
                                              Color(0xFFFF5722)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                            Icons.add_shopping_cart_rounded,
                                            color: Colors.white,
                                            size: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
