import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import 'product_list_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';

class UserShell extends StatefulWidget {
  final int initialIndex;
  const UserShell({super.key, this.initialIndex = 0});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    ProductListScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = Provider.of<CartProvider>(context).itemCount;
    final wishlistCount = Provider.of<WishlistProvider>(context).itemCount;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFFF8A65),
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            elevation: 0,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _badgeIcon(Icons.favorite_outline, wishlistCount),
                activeIcon: _badgeIcon(
                  Icons.favorite_rounded,
                  wishlistCount,
                  active: true,
                ),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: _badgeIcon(Icons.shopping_cart_outlined, cartCount),
                activeIcon: _badgeIcon(
                  Icons.shopping_cart_rounded,
                  cartCount,
                  active: true,
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badgeIcon(IconData icon, int count, {bool active = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            top: -4,
            right: -6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFFF8A65) : Colors.redAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
