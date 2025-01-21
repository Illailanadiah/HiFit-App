import 'package:flutter/material.dart';
import 'package:hifit/mood/moodtracker_screen.dart';
import 'package:hifit/screens/setting_screen.dart';
import 'package:hifit/helper/database_helper.dart';
import 'package:hifit/medications/add_medication.dart';

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

  Widget _dashboardContent() {
    return RefreshIndicator(
      onRefresh: _fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood Logs
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Mood Log',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF21565C), // Deep Blue
                ),
              ),
            ),
            moodLogs.isEmpty
                ? const Center(
                    child: Text(
                      'No mood logs found.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB5B0B3), // Silver
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
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            'Mood: ${log['mood']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF091819), // Black color
                            ),
                          ),
                          subtitle: Text(
                            'Energy Level: ${log['energyLevel']}\nLogged at: ${log['timestamp']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF7D7D7D), // Grey text
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await DatabaseHelper.instance
                                  .deleteMoodLog(log['id']);
                              await _fetchMoodLogs();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mood log deleted'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
            const Divider(),

            // Medications
            const Padding(
              padding: EdgeInsets.all(16.0),
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
                      'No Medications Found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB5B0B3), // Silver color
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
                              await _fetchMedications();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Medication deleted'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
            const Divider(),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMedicationScreen()),
                    ).then((_) => _fetchMedications()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCE5100), // Orange
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    child: const Text(
                      'Add Medication',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MoodTrackerScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF21565C), // Deep Blue
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    child: const Text(
                      'Mode Tracker',
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
        backgroundColor: const Color(0xFF21565C), // Deep Blue
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
            icon: Icon(Icons.fitness_center),
            label: "Fitness",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        selectedItemColor: const Color(0xFF21565C), // Deep Blue color
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
