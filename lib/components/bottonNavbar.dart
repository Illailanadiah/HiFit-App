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
    MoodTrackerScreen(), // Mood Tracker screen
    SettingsScreen(), // Settings screen
  ];

  final List<String> _titles = [
    "Dashboard",
    "Mood Tracker",
    "Settings",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF48a9b6), // Teal Blue
        elevation: 0,
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
        selectedItemColor: const Color(0xFF48a9b6), // Teal Blue
        unselectedItemColor: const Color(0xFFB5B0B3), // Silver
        backgroundColor: const Color(0xFFFFFFFF), // White
      ),
    );
  }
}
