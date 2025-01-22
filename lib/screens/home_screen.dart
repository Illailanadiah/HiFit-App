import 'package:flutter/material.dart';
import 'package:hifit/fitness/fitness_screen.dart';
import 'package:hifit/mood/moodtracker_screen.dart';
import 'package:hifit/screens/setting_screen.dart';
import 'package:hifit/helper/database_helper.dart';
import 'package:hifit/helper/notification_helper.dart';
import 'package:hifit/medications/add_medication.dart';
import 'package:hifit/screens/notification_view_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> medications = [];
  List<Map<String, dynamic>> moodLogs = [];

  final List<Widget> _otherScreens = [
    MoodTrackerScreen(),
    SettingsScreen(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Mood Tracker",
    "Settings",
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchMedications();
    await _fetchMoodLogs();
  }

  Future<void> _fetchMedications() async {
    final db = DatabaseHelper.instance;
    final data = await db.fetchMedications();
    setState(() {
      medications = data;
    });
  }

  Future<void> _fetchMoodLogs() async {
    final db = DatabaseHelper.instance;
    final data = await db.fetchMoodLogs();
    setState(() {
      moodLogs = data;
    });
  }

  Future<void> _deleteMoodLog(int id) async {
    await DatabaseHelper.instance.deleteMoodLog(id);
    await _fetchMoodLogs();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mood log deleted.')),
    );
  }

  Future<void> _deleteMedication(int id, String name) async {
    await DatabaseHelper.instance.deleteMedication(id);
    await _fetchMedications();
    await NotificationHelper.cancelNotification(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name has been marked as taken and removed.')),
    );
  }

  Widget _dashboardContent() {
    return RefreshIndicator(
      onRefresh: _fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood Logs Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Mood Log',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF48a9b6), // Teal Blue
                ),
              ),
            ),
            moodLogs.isEmpty
                ? const Center(
                    child: Text(
                      'No mood logs found.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFfdb3d5), // Pink Blush
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: moodLogs.length,
                    itemBuilder: (context, index) {
                      final log = moodLogs[index];
                      return Card(
                        color: const Color(0xFF77dbe8), // Sky Blue
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: ListTile(
                          title: Text(
                            'Mood: ${log['mood']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White Text
                            ),
                          ),
                          subtitle: Text(
                            'Energy Level: ${log['energyLevel']}\nLogged at: ${log['timestamp']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF21565C), // Deep Blue
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await _deleteMoodLog(log['id']);
                            },
                          ),
                        ),
                      );
                    },
                  ),
            const Divider(),

            // Medications Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your Medications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF48a9b6), // Teal Blue
                ),
              ),
            ),
            medications.isEmpty
                ? const Center(
                    child: Text(
                      'No Medications Found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFfdb3d5), // Pink Blush
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
                        color: const Color(0xFF77dbe8), // Sky Blue
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: ListTile(
                          title: Text(
                            med['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White Text
                            ),
                          ),
                          subtitle: Text(
                            'Dosage: ${med['dosage']} - ${med['time']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF21565C), // Deep Blue
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Mark as Taken') {
                                _deleteMedication(med['id'], med['name']);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'Mark as Taken',
                                child: Text('Mark as Taken'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            const Divider(),

            // Action Buttons Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMedicationScreen()),
                      );
                      if (result != null) {
                        await _fetchMedications();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFfdb3d5), // Pink Blush
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Add Medication',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FitnessRecommendationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF48a9b6), // Teal Blue
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Fitness Recommendations',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: const Color(0xFF48a9b6), // Teal Blue
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationViewScreen()),
              );
            },
          ),
        ],
      ),
      body: _currentIndex == 0 ? _dashboardContent() : _otherScreens[_currentIndex - 1],
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
            icon: Icon(Icons.mood),
            label: "Mood Tracker",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        selectedItemColor: const Color(0xFF48a9b6), // Teal Blue color
        unselectedItemColor: Color(0xFFfdb3d5), // Pink Blush color
      ),
    );
  }
}
