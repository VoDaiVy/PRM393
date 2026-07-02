import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/auth_provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  static const _categoryIcons = {
    'All': '🐾',
    'Food': '🍖',
    'Toys': '🎾',
    'Accessories': '🎀',
    'Healthcare': '💊',
    'Others': '📦',
  };

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.filteredAndSortedItems;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: CustomScrollView(
        slivers: [
          // ── Hero Header + Search ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A65), Color(0xFFFF5722)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(34),
                    bottomRight: Radius.circular(34),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF5722).withValues(alpha: 0.24),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 20,
                  20,
                  20,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.22),
                                  ),
                                ),
                                child: Text(
                                  'Good day, ${user?.fullName.split(' ').first ?? 'Friend'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Find the best\nfor your pet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  height: 1.18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Food, toys, care and tiny joys in one place.',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.82),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.42),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text('🐶', style: TextStyle(fontSize: 36)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: TextField(
                        onChanged: productProvider.setSearchQuery,
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(
                          color: Color(0xFF1A1A2E),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Search food, toys, accessories...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFF8A65,
                                ).withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.search_rounded,
                                color: Color(0xFFFF7043),
                                size: 22,
                              ),
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFF8A65,
                                ).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.tune_rounded,
                                color: Color(0xFFFF7043),
                                size: 21,
                              ),
                            ),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Sort + Category Section ────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 4),
              child: Row(
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  // Sort dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: productProvider.sortOrder,
                        icon: const Icon(
                          Icons.sort_rounded,
                          color: Color(0xFFFF8A65),
                          size: 18,
                        ),
                        isDense: true,
                        style: const TextStyle(
                          color: Color(0xFF1A1A2E),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        items: <String>['Ascending', 'Descending'].map((v) {
                          return DropdownMenuItem(
                            value: v,
                            child: Text(
                              v == 'Ascending' ? '↑ Price' : '↓ Price',
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) productProvider.setSortOrder(v);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: productProvider.categories.length,
                itemBuilder: (context, index) {
                  final cat = productProvider.categories[index];
                  final isSelected = cat == productProvider.selectedCategory;
                  final emoji = _categoryIcons[cat] ?? '🐾';
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: ChoiceChip(
                        label: Text('$emoji $cat'),
                        selected: isSelected,
                        onSelected: (s) {
                          if (s) productProvider.setCategory(cat);
                        },
                        selectedColor: const Color(0xFFFF8A65),
                        backgroundColor: Colors.white,
                        side: isSelected
                            ? BorderSide.none
                            : BorderSide(color: Colors.grey.shade300),
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: isSelected ? 4 : 0,
                        shadowColor: const Color(
                          0xFFFF8A65,
                        ).withValues(alpha: 0.4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Products Header ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8A65).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${products.length}',
                      style: const TextStyle(
                        color: Color(0xFFFF8A65),
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Product Grid ───────────────────────────────────────────
          products.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('😿', style: TextStyle(fontSize: 60)),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = products[index];
                      final isWishlisted = wishlistProvider.isWishlisted(
                        product.id,
                      );
                      return GestureDetector(
                        onTap: () =>
                            context.push('/products/detail/${product.id}'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Image + Wishlist
                              Expanded(
                                flex: 5,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child:
                                          product.imageUrl != null &&
                                              product.imageUrl!.isNotEmpty
                                          ? Image.network(
                                              product.imageUrl!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              errorBuilder: (c, e, s) =>
                                                  _imageFallback(),
                                            )
                                          : _imageFallback(),
                                    ),
                                    // Category badge
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.55,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          product.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Wishlist button
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Builder(
                                        builder: (buttonContext) {
                                          return GestureDetector(
                                            onTap: () {
                                              _flyToNavItem(
                                                buttonContext,
                                                icon: Icons.favorite_rounded,
                                                color: Colors.redAccent,
                                                navIndex: 1,
                                              );
                                              wishlistProvider.toggleWishlist(
                                                product,
                                              );
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.9,
                                                ),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.1),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                isWishlisted
                                                    ? Icons.favorite_rounded
                                                    : Icons.favorite_outline,
                                                color: isWishlisted
                                                    ? Colors.red
                                                    : Colors.grey.shade400,
                                                size: 18,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Info section
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    10,
                                    12,
                                    12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          Builder(
                                            builder: (buttonContext) {
                                              return GestureDetector(
                                                onTap: () {
                                                  _flyToNavItem(
                                                    buttonContext,
                                                    icon: Icons
                                                        .add_shopping_cart_rounded,
                                                    color: const Color(
                                                      0xFFFF7043,
                                                    ),
                                                    navIndex: 2,
                                                  );
                                                  cartProvider.addItem(product);
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        '${product.name} added to cart! 🛒',
                                                      ),
                                                      duration: const Duration(
                                                        seconds: 1,
                                                      ),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          const Color(
                                                            0xFFFF8A65,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      margin:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                          colors: [
                                                            Color(0xFFFF8A65),
                                                            Color(0xFFFF5722),
                                                          ],
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            const Color(
                                                              0xFFFF8A65,
                                                            ).withValues(
                                                              alpha: 0.4,
                                                            ),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          3,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .add_shopping_cart_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              );
                                            },
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
                    }, childCount: products.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _imageFallback() => Container(
    color: const Color(0xFFF0EBE3),
    child: const Center(
      child: Icon(Icons.pets, size: 50, color: Color(0xFFD4B896)),
    ),
  );

  void _flyToNavItem(
    BuildContext sourceContext, {
    required IconData icon,
    required Color color,
    required int navIndex,
  }) {
    final overlay = Overlay.maybeOf(sourceContext);
    final sourceBox = sourceContext.findRenderObject() as RenderBox?;
    final overlayBox = overlay?.context.findRenderObject() as RenderBox?;

    if (overlay == null || sourceBox == null || overlayBox == null) {
      return;
    }

    final mediaQuery = MediaQuery.of(sourceContext);
    final start = sourceBox.localToGlobal(
      sourceBox.size.center(Offset.zero),
      ancestor: overlayBox,
    );
    final navItemWidth = mediaQuery.size.width / 4;
    final end = Offset(
      navItemWidth * (navIndex + 0.5),
      mediaQuery.size.height - mediaQuery.padding.bottom - 34,
    );
    final control = Offset(
      (start.dx + end.dx) / 2,
      math.min(start.dy, end.dy) - 120,
    );

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 720),
          curve: Curves.easeInOutCubic,
          onEnd: entry.remove,
          builder: (context, value, child) {
            final inverse = 1 - value;
            final position =
                start * inverse * inverse +
                control * 2 * inverse * value +
                end * value * value;
            final scale = 1 + math.sin(value * math.pi) * 0.34;
            final opacity = value < 0.78 ? 1.0 : (1 - value) / 0.22;

            return Positioned(
              left: position.dx - 23,
              top: position.dy - 23,
              child: IgnorePointer(
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Transform.scale(scale: scale, child: child),
                ),
              ),
            );
          },
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        );
      },
    );

    overlay.insert(entry);
  }
}
