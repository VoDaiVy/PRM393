import 'package:flutter/material.dart';
import 'screens/post_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/movie_screen.dart';

void main() {
  runApp(const MultiToolApp());
}

class MultiToolApp extends StatelessWidget {
  const MultiToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 - Full Features',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)), // Tông màu Indigo chủ đạo
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PostScreen(),
    const WeatherScreen(),
    const MovieScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 10,
        indicatorColor: const Color(0xFF6366F1).withOpacity(0.2), // Màu nền bao quanh icon khi được chọn
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.list_alt, color: Color(0xFF6366F1), size: 28),
            label: 'Posts',
          ),
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.wb_sunny, color: Color(0xFF0EA5E9), size: 28), // Màu xanh thời tiết
            label: 'Weather',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.movie, color: Color(0xFFE11D48), size: 28), // Màu đỏ rạp phim
            label: 'Movies',
          ),
        ],
      ),
    );
  }
}
