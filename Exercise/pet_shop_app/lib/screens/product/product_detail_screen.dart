import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false)
        .findById(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isWishlisted = wishlistProvider.isWishlisted(product.id);

    // Related products (same category, exclude self)
    final relatedProducts = Provider.of<ProductProvider>(context, listen: false)
        .items
        .where((p) => p.category == product.category && p.id != product.id)
        .take(5)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: const BackButton(color: Color(0xFF1A1A2E)),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                isWishlisted ? Icons.favorite_rounded : Icons.favorite_outline,
                color: isWishlisted ? Colors.red : Colors.grey.shade500,
              ),
              onPressed: () => wishlistProvider.toggleWishlist(product),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero Image ──────────────────────────────────────────
            SizedBox(
              height: 340,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                    child: product.imageUrl != null &&
                            product.imageUrl!.isNotEmpty
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: const Color(0xFFF0EBE3),
                              child: const Icon(Icons.pets,
                                  size: 100, color: Color(0xFFD4B896)),
                            ),
                          )
                        : Container(
                            color: const Color(0xFFF0EBE3),
                            child: const Icon(Icons.pets,
                                size: 100, color: Color(0xFFD4B896)),
                          ),
                  ),
                  // Gradient at bottom for readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8A65).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: Color(0xFFFF5722),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Name + Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A2E),
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF5722),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Static star rating
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                          color: const Color(0xFFFFB300),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '4.5 (128 reviews)',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const Spacer(),
                        _qtyButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (_quantity > 1)
                              setState(() => _quantity--);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                        _qtyButton(
                          icon: Icons.add,
                          onTap: () => setState(() => _quantity++),
                          filled: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Related Products
                  if (relatedProducts.isNotEmpty) ...[
                    const Text(
                      'Related Products',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProducts.length,
                        itemBuilder: (context, i) {
                          final rp = relatedProducts[i];
                          return GestureDetector(
                            onTap: () =>
                                context.push('/products/detail/${rp.id}'),
                            child: Container(
                              width: 130,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: rp.imageUrl != null
                                          ? Image.network(
                                              rp.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (c, e, s) =>
                                                  Container(
                                                color: const Color(0xFFF0EBE3),
                                                child: const Icon(Icons.pets,
                                                    color:
                                                        Color(0xFFD4B896)),
                                              ),
                                            )
                                          : Container(
                                              color: const Color(0xFFF0EBE3),
                                              child: const Icon(Icons.pets,
                                                  color: Color(0xFFD4B896)),
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rp.name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1A2E),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '\$${rp.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFFFF5722),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      // ── Bottom Add to Cart ──────────────────────────────────────
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Price',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                Text(
                  '\$${(product.price * _quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFF5722),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A65), Color(0xFFFF5722)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF8A65).withValues(alpha: 0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    for (var i = 0; i < _quantity; i++) {
                      cartProvider.addItem(product);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$_quantity × ${product.name} added! 🐾'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFFFF8A65),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  label: const Text('Add to Cart',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(
      {required IconData icon, required VoidCallback onTap, bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFFFF8A65) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon,
            size: 18, color: filled ? Colors.white : const Color(0xFF1A1A2E)),
      ),
    );
  }
}
