import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FitnessPlanScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchUserData() async {
    final doc = await _firestore.collection('users').doc('user123').get();
    return doc.data() ?? {};
  }

  Future<List<String>> generatePlan(Map<String, dynamic> userData) async {
    String mood = userData['mood'];
    String energy = userData['energyLevel'];
    String medication = userData['medication'];

    // Simulate predefined plans
    Map<String, Map<String, List<String>>> workoutPlans = {
      "Happy": {
        "High": ["Running", "Cycling"],
        "Medium": ["Yoga", "Brisk Walking"],
        "Low": ["Stretching", "Meditation"]
      },
      "Tired": {
        "High": ["HIIT", "Strength Training"],
        "Medium": ["Pilates", "Light Jogging"],
        "Low": ["Stretching", "Breathing Exercises"]
      },
      "Stressed": {
        "High": ["Kickboxing", "Cardio Dance"],
        "Medium": ["Yoga", "Walking"],
        "Low": ["Meditation", "Breathing Exercises"]
      }
    };

    // Adjust workouts based on medication (simplified)
    if (medication.contains("Painkillers")) {
      workoutPlans["Happy"]?["High"]?.remove("Running");
    }

    return workoutPlans[mood]?[energy] ?? ["No recommendations available"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fitness Plan")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!;
          return FutureBuilder<List<String>>(
            future: generatePlan(userData),
            builder: (context, planSnapshot) {
              if (!planSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final plan = planSnapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    "Your Mood: ${userData['mood']}",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Your Energy Level: ${userData['energyLevel']}",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Your Medication: ${userData['medication']}",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Recommended Workouts:",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  ...plan.map((workout) => Text("- $workout", style: TextStyle(fontSize: 18))),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
