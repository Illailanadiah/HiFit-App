import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hifit/screens/fitness_screen.dart';
import 'package:hifit/screens/medication_screen.dart';
import 'package:hifit/screens/moodtracker_screen.dart';
import 'package:hifit/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  /// Handle navigation when an item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MoodtrackerScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MedicationScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FitnessScreen()),
        );
        break;
      case 3:
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(userId: user.uid)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User not logged in")),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            UserProfileSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: 'Mood Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medication',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Fitness',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
              ],
            ),
          ),
        ],
      ),
    );
  }
}
