import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodTrackerScreen extends StatefulWidget {
  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  String mood = 'Happy';
  String energyLevel = 'High';

  void _saveMood() {
    FirebaseFirestore.instance.collection('moodLogs').add({
      'mood': mood,
      'energyLevel': energyLevel,
      'timestamp': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log Your Mood')),
      body: Column(
        children: [
          DropdownButton<String>(
            value: mood,
            items: ['Happy', 'Tired', 'Stressed']
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (value) => setState(() => mood = value!),
          ),
          DropdownButton<String>(
            value: energyLevel,
            items: ['High', 'Medium', 'Low']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => setState(() => energyLevel = value!),
          ),
          ElevatedButton(
            onPressed: _saveMood,
            child: Text('Save Mood'),
          ),
        ],
      ),
    );
  }
}
