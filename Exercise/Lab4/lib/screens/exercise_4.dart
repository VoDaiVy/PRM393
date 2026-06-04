import 'package:flutter/material.dart';

class Exercise4Screen extends StatelessWidget {
  const Exercise4Screen({super.key});

  final List<Map<String, dynamic>> _groups = const [
    {
      'title': 'Team A',
      'color': Color(0xFF6C63FF),
      'items': [
        {
          'name': 'Vo Dai Vy',
          'initials': 'KL',
          'color': Color(0xFFF06292),
          'role': 'Developer',
        },
        {
          'name': 'Pham Le Huyen Tran',
          'initials': 'EW',
          'color': Color(0xFFBA68C8),
          'role': 'Designer',
        },
        {
          'name': 'Ho Sy Hung',
          'initials': 'RB',
          'color': Color(0xFF90A4AE),
          'role': 'Manager',
        },
      ],
    },
    {
      'title': 'Team B',
      'color': Color(0xFF00B8D9),
      'items': [
        {
          'name': 'Toyah Downs',
          'initials': 'TD',
          'color': Color(0xFFE57373),
          'role': 'QA Tester',
        },
        {
          'name': 'Tyla Kane',
          'initials': 'TK',
          'color': Color(0xFF4DB6AC),
          'role': 'Developer',
        },
      ],
    },
    {
      'title': 'Team C',
      'color': Color(0xFFFFAB00),
      'items': [
        {
          'name': 'Marcus Romero',
          'initials': 'MR',
          'color': Color(0xFFFFB74D),
          'role': 'Analyst',
        },
        {
          'name': 'Farrah Parkes',
          'initials': 'FP',
          'color': Color(0xFF9575CD),
          'role': 'Support',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Group List View Demo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        itemCount: _groups.length,
        itemBuilder: (context, sectionIndex) {
          final group = _groups[sectionIndex];
          final items = group['items'] as List<Map<String, dynamic>>;
          final groupColor = group['color'] as Color;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  bottom: 12.0,
                  left: 4.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: groupColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      group['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: groupColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: groupColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${items.length} Members',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: groupColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...items.map((item) {
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
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: item['color'].withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: item['color'].withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  item['initials'],
                                  style: TextStyle(
                                    color: item['color'],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['role'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F6F8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
