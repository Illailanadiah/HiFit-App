import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HiFit')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome to HiFit!', style: TextStyle(fontSize: 24)),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/moodTracker'),
            child: Text('Log Mood'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/medications'),
            child: Text('Manage Medications'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/fitnessPlan'),
            child: Text('Fitness Recommendations'),
          ),
        ],
      ),
    );
  }
}
