import 'package:flutter/material.dart';
import 'dart:math';

class BackgroundColorChanger extends StatefulWidget {
  const BackgroundColorChanger({super.key});

  @override
  State<BackgroundColorChanger> createState() => _BackgroundColorChangerState();
}

class _BackgroundColorChangerState extends State<BackgroundColorChanger> {
  Color _backgroundColor = Colors.white;
  String _colorName = 'White';

  void _changeColor(Color color, String name) {
    setState(() {
      _backgroundColor = color;
      _colorName = name;
    });
  }

  void _randomColor() {
    final random = Random();
    final r = random.nextInt(256);
    final g = random.nextInt(256);
    final b = random.nextInt(256);
    setState(() {
      _backgroundColor = Color.fromRGBO(r, g, b, 1);
      _colorName = 'Random RGB($r, $g, $b)';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán độ sáng của màu nền để tự động đổi màu chữ cho dễ nhìn
    final textColor = _backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('2. Background Color Changer')),
      backgroundColor: _backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Color:',
              style: TextStyle(fontSize: 24, color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              _colorName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => _changeColor(Colors.red, 'Red'),
                  child: const Text('Red', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => _changeColor(Colors.green, 'Green'),
                  child: const Text('Green', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => _changeColor(Colors.blue, 'Blue'),
                  child: const Text('Blue', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _randomColor,
              child: const Text('Generate Random Color'),
            ),
          ],
        ),
      ),
    );
  }
}
