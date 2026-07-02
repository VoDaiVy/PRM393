import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/wishlist_provider.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authProvider = AuthProvider();
  await authProvider.init();

  final router = createRouter(authProvider);

  runApp(PetShopApp(authProvider: authProvider, router: router));
}

class PetShopApp extends StatelessWidget {
  final AuthProvider authProvider;
  final GoRouter router;
  
  const PetShopApp({Key? key, required this.authProvider, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp.router(
        title: 'Pet Shop',
        theme: ThemeData(
            primaryColor: const Color(0xFFFF8A65), // Warm soft orange
            scaffoldBackgroundColor: const Color(0xFFFBF8F1), // Soft beige
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF8A65),
              primary: const Color(0xFFFF8A65),
              secondary: const Color(0xFF4DB6AC), // Soft teal for contrast
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.nunitoTextTheme(),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFFFBF8F1),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: GoogleFonts.nunito(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A65),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 3,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            cardTheme: const CardThemeData(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              elevation: 2,
              shadowColor: Colors.black12,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFFF8A65), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        ),
    );
  }
}
