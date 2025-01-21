import 'package:flutter/material.dart';
import 'package:hifit/helper/database_helper.dart';
import 'package:hifit/fitness/fitness_screen.dart';
import 'package:hifit/mood/moodtracker_screen.dart';
import 'package:hifit/medications/add_medication.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> medications = [];

  @override
  void initState() {
    super.initState();
    _fetchMedications();
  }

  Future<void> _fetchMedications() async {
    final db = DatabaseHelper.instance;
    final data = await db.fetchMedications();
    setState(() {
      medications = data;
    });
  }

  Widget _medicationList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Your Medications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF21565C), // Deep Blue
            ),
          ),
        ),
        medications.isEmpty
            ? const Center(
                child: Text(
                  'No medications added.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFB5B0B3), // Silver
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final med = medications[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        med['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF091819), // Black
                        ),
                      ),
                      subtitle: Text(
                        'Dosage: ${med['dosage']} - ${med['time']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF7D7D7D), // Grey
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await DatabaseHelper.instance
                              .deleteMedication(med['id']);
                          _fetchMedications();
                        },
                      ),
                    ),
                  );
                },
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMedicationScreen()),
            ).then((_) => _fetchMedications()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCE5100), // Orange
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            ),
            child: const Text(
              'Add Medication',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fitnessOverview() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FitnessRecommendationScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF21565C), // Deep Blue
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Fitness Recommendations',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.fitness_center,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _moodOverview() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MoodTrackerScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFCE5100), // Orange
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Mood Tracker',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.mood,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fitnessOverview(),
          _moodOverview(),
          _medicationList(),
        ],
      ),
    );
  }
}
