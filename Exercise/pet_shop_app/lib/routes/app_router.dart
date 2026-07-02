import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/product/user_shell.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/product/add_edit_product_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/revenue/revenue_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../providers/auth_provider.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authProvider.isAuthenticated;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) {
        return authProvider.currentUser?.role == 'admin'
            ? '/admin'
            : '/products';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const UserShell(),
        routes: [
          GoRoute(
            path: 'detail/:id',
            builder: (context, state) =>
                ProductDetailScreen(productId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditProductScreen(),
          ),
          GoRoute(
            path: 'edit/:id',
            builder: (context, state) =>
                AddEditProductScreen(productId: state.pathParameters['id']),
          ),
        ],
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(
        path: '/revenue',
        builder: (context, state) => const RevenueScreen(),
      ),
    ],
  );
}
