import 'package:flutter/material.dart';

class StudentInformationForm extends StatefulWidget {
  const StudentInformationForm({super.key});

  @override
  State<StudentInformationForm> createState() => _StudentInformationFormState();
}

class _StudentInformationFormState extends State<StudentInformationForm> {
  final _fullNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _classController = TextEditingController();

  String _displayInfo = '';

  @override
  void dispose() {
    _fullNameController.dispose();
    _studentIdController.dispose();
    _classController.dispose();
    super.dispose();
  }

  void _showInformation() {
    setState(() {
      if (_fullNameController.text.isEmpty &&
          _studentIdController.text.isEmpty &&
          _classController.text.isEmpty) {
        _displayInfo = 'Please enter your information.';
      } else {
        _displayInfo = 'Full Name: ${_fullNameController.text}\n'
            'Student ID: ${_studentIdController.text}\n'
            'Class: ${_classController.text}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information Form'),
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter Student Details',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: 'Student ID',
                prefixIcon: const Icon(Icons.badge),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _classController,
              decoration: InputDecoration(
                labelText: 'Class',
                prefixIcon: const Icon(Icons.class_),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showInformation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: const Text('Show Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            if (_displayInfo.isNotEmpty)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.indigo),
                        SizedBox(width: 8),
                        Text('Student Information',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo)),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      _displayInfo,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
