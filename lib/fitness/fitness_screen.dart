import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hifit/helper/database_helper.dart';

class FitnessRecommendationScreen extends StatelessWidget {
  final Map<String, String> fitnessLinks = {
    'Light Yoga': 'https://www.youtube.com/watch?v=uq3IctUxvQc',
    'Gentle Walking': 'https://www.youtube.com/watch?v=Fdz5jG4qGS8',
    'Moderate Cardio': 'https://www.youtube.com/watch?v=5YJkvUXIGi0',
  };

  /// Generate fitness recommendation based on medication and mood data
  String generateRecommendation(Map<String, dynamic> medication, Map<String, dynamic>? moodLog) {
    final String type = medication['type'];
    final int interval = medication['interval'];
    final String mood = moodLog?['mood'] ?? 'Neutral';
    final String energyLevel = moodLog?['energyLevel'] ?? 'Medium';

    if (mood == 'Happy' && energyLevel == 'High') {
      if (type.toLowerCase() == 'pill' && interval < 12) {
        return 'Light Yoga';
      } else if (type.toLowerCase() == 'syringe') {
        return 'Gentle Walking';
      } else {
        return 'Moderate Cardio';
      }
    } else if (mood == 'Tired' || energyLevel == 'Low') {
      return 'Light Yoga';
    } else if (mood == 'Stressed') {
      return 'Gentle Walking';
    }
    return 'Custom workouts based on your mood and medication type.';
  }

  /// Fetch the latest mood log
  Future<Map<String, dynamic>?> fetchLatestMoodLog() async {
    final db = DatabaseHelper.instance;
    final moodLogs = await db.fetchMoodLogs();
    return moodLogs.isNotEmpty ? moodLogs.first : null;
  }

  Future<void> openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Recommendations'),
        backgroundColor: const Color(0xFF21565C), // Deep Blue
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchLatestMoodLog(),
        builder: (context, moodSnapshot) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper.instance.fetchMedications(),
            builder: (context, medSnapshot) {
              if (medSnapshot.connectionState == ConnectionState.waiting ||
                  moodSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!medSnapshot.hasData || medSnapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No medications found to base recommendations on.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF7D7D7D)),
                  ),
                );
              }

              final medications = medSnapshot.data!;
              final moodLog = moodSnapshot.data;

              return ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final med = medications[index];
                  final recommendation = generateRecommendation(med, moodLog);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        'Workout Plan for ${med['name']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        recommendation,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF7D7D7D)),
                      ),
                      trailing: const Icon(Icons.link, color: Color(0xFFCE5100)), // Orange icon
                      onTap: () {
                        if (fitnessLinks.containsKey(recommendation)) {
                          openLink(fitnessLinks[recommendation]!);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('No Link Available'),
                              content: const Text('No external link is available for this recommendation.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
