
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MoodScreen extends StatefulWidget {
  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String selectedMood = ""; // To store the selected mood

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick your Mood')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pick your Mood',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            // Row of mood cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodCard(
                    'Happy', Colors.blue, Icons.sentiment_very_satisfied),
                _buildMoodCard(
                    'Terrified', Colors.orange, Icons.sentiment_dissatisfied),
                _buildMoodCard(
                    'Angry', Colors.red, Icons.sentiment_very_dissatisfied),
              ],
            ),
            SizedBox(height: 32),
            if (selectedMood.isNotEmpty)
              Column(
                children: [
                  Text(
                    'You selected: $selectedMood',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveMoodToFirestore,
                    child: Text('Save Mood'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(String mood, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood; // Update selected mood
          print('Selected Mood: $selectedMood'); // Debugging
        });
      },
      child: Container(
        width: 100,
        height: 200,
        decoration: BoxDecoration(
          color: selectedMood == mood
              ? color.withOpacity(0.8)
              : color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 50, color: selectedMood == mood ? Colors.white : color),
            SizedBox(height: 16),
            Text(
              mood,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: selectedMood == mood ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMoodToFirestore() async {
    try {
      // Save the selected mood to Firestore
      await _firestore.collection('moods').add({
        'mood': selectedMood,
        'timestamp':
            FieldValue.serverTimestamp(), // Server timestamp for sorting
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mood saved successfully!')),
      );

      // Reset the selected mood
      setState(() {
        selectedMood = "";
      });
    } catch (e) {
      // Show an error message with detailed logging
      print('Error saving mood: $e'); // Log the error to the console
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save mood: $e')),
      );
    }
  }
}

class MoodModel { 
  final String selectedMood;

  const MoodModel({ 
  required this.selectedMood,
});

 toJson() {
    return {
      'selectedMood': selectedMood,
    };
  }
}
