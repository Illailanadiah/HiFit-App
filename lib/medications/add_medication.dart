import 'package:flutter/material.dart';

class AddMedicationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Medication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Medication Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dosageController,
              decoration: InputDecoration(
                labelText: 'Dosage',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add logic to save medication to the database or list
                Navigator.pop(context);
              },
              child: Text('Add Medication'),
            ),
            
          ],
        ),
      ),
    );
  }
}

class SetReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Select Medication',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Set Time',
                border: OutlineInputBorder(),
              ),
              onTap: () {
                // Show time picker
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save reminder logic here
              },
              child: Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
