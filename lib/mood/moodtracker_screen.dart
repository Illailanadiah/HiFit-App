import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Track Mood & Energy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood & Energy Tracking',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Mood (e.g., Happy, Sad)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mood, color: Colors.blue),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Energy Level (1-10)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.battery_full, color: Colors.green),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save mood and energy logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
