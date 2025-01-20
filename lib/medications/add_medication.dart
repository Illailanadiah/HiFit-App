import 'package:flutter/material.dart';

class AddMedicationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();

  void _saveMedication(BuildContext context) {
    // Save to Firebase
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Medication')),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Medication Name'),
          ),
          TextField(
            controller: dosageController,
            decoration: InputDecoration(labelText: 'Dosage'),
          ),
          ElevatedButton(
            onPressed: () => _saveMedication(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
