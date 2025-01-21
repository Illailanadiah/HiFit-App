import 'package:flutter/material.dart';
import 'package:hifit/mood/moodtracker_screen.dart';
import 'package:hifit/screens/home_screen.dart';
import 'package:hifit/screens/setting_screen.dart';

class BottomNavBarApp extends StatefulWidget {
  @override
  _BottomNavBarAppState createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Dashboard screen
    MoodTrackerScreen(), // Fitness Recommendation screen
    SettingsScreen(), // Settings screen
  ];

  final List<String> _titles = [
    "Dashboard",
    "Fitness",
    "Settings",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: const Color(0xFF21565C), // Deep Blue
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
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
