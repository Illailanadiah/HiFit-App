import 'package:flutter/material.dart';

class MedicationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Medications')),
      body: ListView.builder(
        itemCount: 5, // Replace with Firestore data count
        itemBuilder: (context, index) => ListTile(
          title: Text('Medication $index'),
          onTap: () => Navigator.pushNamed(context, '/medicationDetails'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addMedication'),
        child: Icon(Icons.add),
      ),
    );
  }
}
