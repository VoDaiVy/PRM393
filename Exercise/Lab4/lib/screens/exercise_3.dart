import 'package:flutter/material.dart';

class Exercise3Screen extends StatefulWidget {
  const Exercise3Screen({super.key});

  @override
  State<Exercise3Screen> createState() => _Exercise3ScreenState();
}

class _Exercise3ScreenState extends State<Exercise3Screen> {
  final List<Map<String, dynamic>> _items = [
    {'title': 'LidTerm', 'subtitle': 'Status 3', 'isFavorite': false, 'icon': Icons.layers_rounded},
    {'title': 'CraftRock', 'subtitle': 'Status 4', 'isFavorite': false, 'icon': Icons.diamond_rounded},
    {'title': 'BootClay', 'subtitle': 'Status 5', 'isFavorite': false, 'icon': Icons.shield_rounded},
    {'title': 'CheckSuit', 'subtitle': 'Status 6', 'isFavorite': false, 'icon': Icons.check_circle_rounded},
    {'title': 'TeamSake', 'subtitle': 'Status 7', 'isFavorite': false, 'icon': Icons.people_rounded},
    {'title': 'NewLaugh', 'subtitle': 'Status 8', 'isFavorite': false, 'icon': Icons.mood_rounded},
    {'title': 'BlueCop', 'subtitle': 'Status 9', 'isFavorite': false, 'icon': Icons.local_police_rounded},
    {'title': 'WildTent', 'subtitle': 'Status 10', 'isFavorite': false, 'icon': Icons.park_rounded},
  ];

  void _toggleFavorite(int index) {
    setState(() {
      _items[index]['isFavorite'] = !_items[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Getting Started',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF3F3D56)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.sort_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                onPressed: () {},
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item['icon'],
                                  color: const Color(0xFF6C63FF),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D3748),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['subtitle'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    item['isFavorite']
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    key: ValueKey<bool>(item['isFavorite']),
                                    color: item['isFavorite']
                                        ? const Color(0xFFFF4757)
                                        : Colors.grey.shade400,
                                    size: 28,
                                  ),
                                ),
                                onPressed: () => _toggleFavorite(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: _items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
