import 'package:flutter/material.dart';
import 'package:hifit/helper/database_helper.dart';
import 'package:hifit/screens/success_screen.dart';
import 'package:hifit/helper/notification_helper.dart';

class AddMedicationScreen extends StatefulWidget {
  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController intervalController = TextEditingController();
  String selectedType = 'Pill'; // Default medication type
  TimeOfDay? selectedTime;

  Future<void> _saveMedication() async {
    if (nameController.text.trim().isEmpty ||
        dosageController.text.trim().isEmpty ||
        intervalController.text.trim().isEmpty ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    final db = DatabaseHelper.instance;
    final int id = await db.addMedication({
      'name': nameController.text.trim(),
      'dosage': dosageController.text.trim(),
      'type': selectedType,
      'interval': int.tryParse(intervalController.text.trim()) ?? 24,
      'time': selectedTime!.format(context),
    });

    // Schedule the initial notification
    await NotificationHelper.scheduleNotification(
      id,
      'Time to Take Your Medicine',
      'It\'s time to take ${nameController.text.trim()}!',
      DateTime.now().add(Duration(
          hours: int.tryParse(intervalController.text.trim()) ?? 24)),
    );

    // Navigate to Success Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SuccessScreen()),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Medication'),
        backgroundColor: const Color(0xFF48a9b6), // Teal Blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medicine Name *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF21565C), // Deep Blue
                ),
              ),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF21565C), // Deep Blue
                ),
              ),
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
                'Medication Type *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF21565C), // Deep Blue
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ['Pill', 'Syringe', 'Liquid']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Interval (Hours) *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF21565C), // Deep Blue
                ),
              ),
              TextField(
                controller: intervalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter interval in hours (e.g., 24)',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Starting Time *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF21565C), // Deep Blue
                ),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text(
                  selectedTime == null
                      ? 'Pick Time'
                      : 'Selected Time: ${selectedTime!.format(context)}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFfdb3d5), // Pink Blush
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveMedication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48a9b6), // Teal Blue
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 18.0,
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
      ),
    );
  }
}
