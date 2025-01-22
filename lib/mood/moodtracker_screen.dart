import 'package:flutter/material.dart';
import 'package:hifit/helper/database_helper.dart';

class MoodTrackerScreen extends StatefulWidget {
  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  String mood = 'Happy';
  String energyLevel = 'High';

  Future<void> _saveMood() async {
    final db = DatabaseHelper.instance;
    await db.addMoodLog({
      'mood': mood,
      'energyLevel': energyLevel,
      'timestamp': DateTime.now().toString(),
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mood Logged'),
        content: const Text('Your mood has been successfully logged.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF48a9b6)), // Teal Blue
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Your Mood'),
        backgroundColor: const Color(0xFF48a9b6), // Teal Blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How do you feel today?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF21565C), // Deep Blue
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: mood,
              items: ['Happy', 'Tired', 'Stressed']
                  .map((m) => DropdownMenuItem(
                        value: m,
                        child: Text(
                          m,
                          style: const TextStyle(color: Color(0xFF091819)), // Black
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => mood = value!),
              decoration: const InputDecoration(
                labelText: 'Mood',
                labelStyle: TextStyle(color: Color(0xFF48a9b6)), // Teal Blue
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48a9b6)), // Teal Blue
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: energyLevel,
              items: ['High', 'Medium', 'Low']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Color(0xFF091819)), // Black
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => energyLevel = value!),
              decoration: const InputDecoration(
                labelText: 'Energy Level',
                labelStyle: TextStyle(color: Color(0xFF48a9b6)), // Teal Blue
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48a9b6)), // Teal Blue
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveMood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFfdb3d5), // Pink Blush
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 16.0,
                  ),
                ),
                child: const Text(
                  'Save Mood',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
