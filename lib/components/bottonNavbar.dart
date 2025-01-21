import 'package:flutter/material.dart';
import 'package:hifit/calendar/calendar_screen.dart';
import 'package:hifit/mood/moodtracker_screen.dart';
import 'package:hifit/screens/dashboard_screen.dart';
import 'package:hifit/screens/setting_screen.dart';


class BottomNavBarApp extends StatefulWidget {
  @override
  _BottomNavBarAppState createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(), // Replace with your dashboard screen
    CalendarScreen(), // Replace with your calendar screen
    MoodTrackerScreen(), // Replace with your mood tracker screen
    SettingsScreen(), // Replace with your settings screen
  ];

  final List<String> _titles = [
    "Dashboard",
    "Calendar",
    "Mood Tracker",
    "Settings",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.purple,
      ),
      body: _screens[_currentIndex],
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
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
