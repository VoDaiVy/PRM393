import 'package:flutter/material.dart';
import 'personal_profile_card.dart';
import 'business_card.dart';
import 'product_display_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Labs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LabScreen(),
    );
  }
}

class LabScreen extends StatelessWidget {
  const LabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('StatelessWidget Labs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 20),
            Text(
              '1. Personal Profile Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            PersonalProfileCard(),
            
            Divider(height: 40, thickness: 2),
            
            Text(
              '2. Business Card App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            BusinessCard(),

            Divider(height: 40, thickness: 2),
            
            Text(
              '3. Simple Product Display',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ProductDisplayScreen(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
