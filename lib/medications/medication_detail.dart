import 'package:flutter/material.dart';

class MedicationDetailsScreen extends StatelessWidget {
  final String medicationName;

  MedicationDetailsScreen({required this.medicationName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$medicationName Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicationName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Dosage: 500mg', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Frequency: Twice a day', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                            },
              icon: Icon(Icons.notifications_active),
              label: Text('Set Reminder'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
