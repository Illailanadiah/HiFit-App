import 'package:flutter/material.dart';
import 'package:hifit/helper/database_helper.dart';
import 'package:hifit/helper/notification_helper.dart';

class AddMedicationScreen extends StatefulWidget {
  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  TimeOfDay? selectedTime;

  Future<void> _saveMedication(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        dosageController.text.trim().isEmpty ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final DateTime now = DateTime.now();
    final DateTime scheduleTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final db = DatabaseHelper.instance;
    final id = await db.addMedication({
      'name': nameController.text.trim(),
      'dosage': dosageController.text.trim(),
      'time': selectedTime!.format(context),
    });

    // Schedule notification
    await NotificationHelper.scheduleNotification(
      id,
      'Medication Reminder',
      'It\'s time to take ${nameController.text.trim()} (${dosageController.text.trim()} mg)',
      scheduleTime,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Medication added! Reminder set for ${selectedTime!.format(context)}.',
        ),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Mediminder'),
        backgroundColor: const Color(0xFF21565C), // Deep Blue
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medicine Name *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter medicine name',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dosage in mg *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: dosageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter dosage',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Starting Time *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE5100), // Orange
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                selectedTime == null
                    ? 'Pick Time'
                    : 'Selected Time: ${selectedTime!.format(context)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () => _saveMedication(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21565C), // Deep Blue
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
