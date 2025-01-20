import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hifit/fitness/fitnessplan_screen.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedMood = "Happy";
  String selectedEnergy = "High";
  String medication = "";

  void saveUserInput() async {
    // Save the user input to Firestore
    await _firestore.collection('users').doc('user123').set({
      'mood': selectedMood,
      'energyLevel': selectedEnergy,
      'medication': medication,
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FitnessPlanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Input Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedMood,
              items: ["Happy", "Tired", "Stressed"]
                  .map((mood) => DropdownMenuItem(
                        value: mood,
                        child: Text(mood),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedMood = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedEnergy,
              items: ["High", "Medium", "Low"]
                  .map((energy) => DropdownMenuItem(
                        value: energy,
                        child: Text(energy),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedEnergy = value!;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Enter Medication"),
              onChanged: (value) {
                medication = value;
              },
            ),
            ElevatedButton(
              onPressed: saveUserInput,
              child: Text("Save and Generate Plan"),
            ),
          ],
        ),
      ),
    );
  }
}
