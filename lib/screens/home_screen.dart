import 'package:flutter/material.dart';
import 'package:hifit/mood/moodtracker_screen.dart';
import 'package:hifit/screens/setting_screen.dart';
import 'package:hifit/helper/database_helper.dart';
import 'package:hifit/helper/notification_helper.dart';
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

  Future<void> _scheduleMedicationNotification(Map<String, dynamic> med) async {
    final int id = med['id'];
    final String name = med['name'];
    final DateTime scheduledTime = DateTime.parse(med['time']); // Ensure time is in correct format

    await NotificationHelper.scheduleNotification(
      id,
      'Time to Take Your Medicine',
      'Don\'t forget to take $name!',
      scheduledTime,
    );
  }

  Future<void> _dashboardNotification(String title, String message) async {
    await NotificationHelper.showInstantNotification(
      0,
      title,
      message,
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
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
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
                              await _dashboardNotification(
                                'Mood Log Deleted',
                                'You removed a mood log entry.',
                              );
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

            // Medications Section
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
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
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
                              await _dashboardNotification(
                                'Medication Deleted',
                                'You removed ${med['name']} from your medications.',
                              );
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
                        await _scheduleMedicationNotification(result);
                        await _dashboardNotification(
                          'New Medication Added',
                          '${result['name']} has been added to your list.',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCE5100), // Orange
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
                            builder: (context) => MoodTrackerScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF21565C), // Deep Blue
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Mood Tracker',
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
    );
  }
}
