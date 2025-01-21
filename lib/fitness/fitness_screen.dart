import 'package:flutter/material.dart';
import 'package:hifit/helper/database_helper.dart';
import 'package:hifit/helper/notification_helper.dart';

class FitnessRecommendationScreen extends StatelessWidget {
  /// Generate fitness recommendation based on medication details
  String generateRecommendation(Map<String, dynamic> medication) {
    final String type = medication['type'];
    final int interval = medication['interval'];

    if (type.toLowerCase() == 'pill' && interval < 12) {
      return 'Light Yoga or Stretching is recommended due to frequent intake.';
    } else if (type.toLowerCase() == 'syringe') {
      return 'Gentle Walking or Meditation to avoid strain.';
    } else if (interval >= 12) {
      return 'Moderate Cardio or Strength Training can be done safely.';
    }
    return 'Custom workouts based on your medication type.';
  }

  Future<void> scheduleFitnessReminder() async {
  await NotificationHelper.scheduleNotification(
    1, // Unique ID for fitness notifications
    'Fitness Reminder',
    'Don\'t forget your daily workout! Stay healthy and active.',
    DateTime.now().add(Duration(hours: 24)), // Notify after 24 hours
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Recommendation'),
        backgroundColor: const Color(0xFF21565C), // Deep Blue
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.fetchMedications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No medications found to base recommendations on.',
                style: TextStyle(fontSize: 16, color: Color(0xFF7D7D7D)),
              ),
            );
          }

          final medications = snapshot.data!;
          return ListView.builder(
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final med = medications[index];
              final recommendation = generateRecommendation(med);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    'Workout Plan for ${med['name']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091819), // Black color
                    ),
                  ),
                  subtitle: Text(
                    recommendation,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF7D7D7D)),
                  ),
                  trailing: const Icon(Icons.fitness_center, color: Color(0xFFCE5100)), // Orange icon
                ),
              );
            },
          );
        },
      ),
    );
  }
}
