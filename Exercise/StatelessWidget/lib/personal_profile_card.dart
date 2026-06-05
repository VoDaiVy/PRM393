import 'package:flutter/material.dart';

class PersonalProfileCard extends StatelessWidget {
  const PersonalProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Profile picture
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
              'assets/images/avatar.jpg', // Đổi tên file cho khớp với ảnh bạn vừa thả vào
            ),
          ),

          // 2. Full name
          const Text(
            'Võ Đại Vỹ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // 3. Major
          const Text(
            'Chuyên ngành: Kỹ thuật Phần mềm',
            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
          ),
          const SizedBox(height: 16),

          // 4. Short bio
          const Text(
            'Hiện đang học về lập trình di động với Flutter. Thích học hỏi và khám phá công nghệ mới mỗi ngày.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),

          // 5. Contact button
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.email),
            label: const Text('Liên hệ với tôi'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
