import 'package:flutter/material.dart';
import 'package:hifit/calendar/calendar_screen.dart';
import 'package:hifit/helper/notification_helper.dart';
import 'package:hifit/mood/moodtracker_screen.dart';
import 'package:hifit/screens/dashboard_screen.dart';
import 'package:hifit/screens/setting_screen.dart';
import 'package:hifit/helper/database_helper.dart';
import 'package:hifit/fitness/fitness_screen.dart';
import 'package:hifit/medications/add_medication.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Map<String, dynamic>> medications = [];

  final List<Widget> _screens = [
    DashboardScreen(), // Dashboard screen
    CalendarScreen(), // Calendar screen
    MoodTrackerScreen(), // Mood Tracker screen
    SettingsScreen(), // Settings screen
  ];

  final List<String> _titles = [
    "Dashboard",
    "Calendar",
    "Mood Tracker",
    "Settings",
  ];

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

  Widget _dashboardScreen() {
    return Container(
      color: const Color(0xFFF5F5F5), // Light background for the body
      child: Column(
        children: [
          Expanded(
            child: medications.isEmpty
                ? const Center(
                    child: Text(
                      'No Medications Found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFB5B0B3), // Silver color
                      ),
                    ),
                  )
                : ListView.builder(
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
                              color: Color(0xFF091819), // Black color
                            ),
                          ),
                          subtitle: Text(
                            'Dosage: ${med['dosage']} - ${med['time']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF7D7D7D), // Grey text
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await DatabaseHelper.instance
                                  .deleteMedication(med['id']);
                                  await NotificationHelper.cancelNotification(med['id']);
                              _fetchMedications();
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddMedicationScreen()),
              ).then((_) => _fetchMedications()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE5100), // Orange color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
              ),
              child: const Text(
                'Add Medication',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: const Color(0xFF21565C), // Deep Blue
      ),
      body: _currentIndex == 0 ? _dashboardScreen() : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: "Mood Tracker",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        selectedItemColor: const Color(0xFF21565C), // Deep Blue color
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FitnessRecommendationScreen()),
              ),
              child: const Icon(Icons.fitness_center),
              backgroundColor: const Color(0xFFCE5100), // Orange color
            )
          : null,
    );
  }
}
