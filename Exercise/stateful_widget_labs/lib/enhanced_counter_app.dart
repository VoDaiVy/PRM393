import 'package:flutter/material.dart';

class EnhancedCounterApp extends StatefulWidget {
  const EnhancedCounterApp({super.key});

  @override
  State<EnhancedCounterApp> createState() => _EnhancedCounterAppState();
}

class _EnhancedCounterAppState extends State<EnhancedCounterApp> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      _counter--;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Conditional UI rendering: Text color is red when value > 10
    final textColor = _counter > 10 ? Colors.red : Colors.black;

    return Scaffold(
      appBar: AppBar(title: const Text('1. Enhanced Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Number:', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text(
              '$_counter',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrement,
                  child: const Text('- Decrease'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _increment,
                  child: const Text('+ Increase'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
