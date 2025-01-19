import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  HomePage() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.subscribeToTopic('reminders');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HiFit Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to HiFit!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Manage your medications and fitness routines effortlessly.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.medication, size: 40, color: Colors.blue),
                title: Text('Medications'),
                subtitle: Text('View and manage your medications'),
                onTap: () {
                  Navigator.pushNamed(context, '/medications');
                },
              ),
            ),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.fitness_center, size: 40, color: Colors.green),
                title: Text('Fitness Routines'),
                subtitle: Text('Track your fitness goals'),
                onTap: () {
                  Navigator.pushNamed(context, '/fitness');
                },
              ),
            ),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.track_changes, size: 40, color: Colors.purple),
                title: Text('Mood & Energy'),
                subtitle: Text('Log and monitor your progress'),
                onTap: () {
                  Navigator.pushNamed(context, '/tracking');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
