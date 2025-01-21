import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hifit/helper/database_helper.dart';

class FitnessRecommendationScreen extends StatelessWidget {
  final Map<String, String> fitnessLinks = {
    'Light Yoga': 'https://www.youtube.com/watch?v=uq3IctUxvQc',
    'Gentle Walking': 'https://www.youtube.com/watch?v=Fdz5jG4qGS8',
    'Moderate Cardio': 'https://www.youtube.com/watch?v=5YJkvUXIGi0',
  };

  /// Fitness steps for recommendations
  final Map<String, List<String>> fitnessSteps = {
    'Light Yoga': [
      'Step 1: Begin with deep breathing exercises.',
      'Step 2: Perform basic yoga poses like Child’s Pose and Cat-Cow Pose.',
      'Step 3: End with light stretches and relaxation.',
    ],
    'Gentle Walking': [
      'Step 1: Start with a slow-paced walk for 5 minutes.',
      'Step 2: Walk at a moderate pace for 10-15 minutes.',
      'Step 3: Cool down with light stretching.',
    ],
    'Moderate Cardio': [
      'Step 1: Warm up with 5 minutes of brisk walking.',
      'Step 2: Perform activities like cycling or jogging for 20 minutes.',
      'Step 3: Finish with 5 minutes of light jogging or walking.',
    ],
  };

  /// Generate fitness recommendation based on medication and mood data
  String generateRecommendation(
      Map<String, dynamic> medication, Map<String, dynamic>? moodLog) {
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

  Future<void> openLink(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Ensures it opens in the external browser
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      // Show an error dialog to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Unable to open the link: $url'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    elevation: 4,
                    child: ExpansionTile(
                      title: Text(
                        'Workout Plan for ${med['name']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        recommendation,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF7D7D7D)),
                      ),
                      children: [
                        if (fitnessSteps.containsKey(recommendation)) ...[
                          Stepper(
                            physics: const NeverScrollableScrollPhysics(),
                            steps: fitnessSteps[recommendation]!
                                .map(
                                  (step) => Step(
                                    title: Text(
                                      step,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    content: const SizedBox.shrink(),
                                    isActive: true,
                                  ),
                                )
                                .toList(),
                            currentStep: 0,
                            onStepTapped: (step) {},
                            controlsBuilder: (context, _) =>
                                const SizedBox.shrink(),
                          ),
                        ],
                        ElevatedButton.icon(
                          onPressed: () {
                            if (fitnessLinks.containsKey(recommendation)) {
                              openLink(context, fitnessLinks[recommendation]!);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('No Link Available'),
                                  content: const Text(
                                    'No external link is available for this recommendation.',
                                  ),
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
                          icon: const Icon(Icons.link),
                          label: const Text('Watch Video'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCE5100),
                          ),
                        ),
                      ],
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
