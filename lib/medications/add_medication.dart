import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hifit/screens/success_screen.dart';

class AddMedicineScreen extends StatefulWidget {
  final String? medicationId; // Pass medicationId for editing

  const AddMedicineScreen({Key? key, this.medicationId}) : super(key: key);

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedMedicineType = "";
  int selectedInterval = 0;
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if (widget.medicationId != null) {
      _loadMedicationData();
    }
  }

  void _loadMedicationData() async {
    final medication = await _firestore
        .collection('medications')
        .doc(widget.medicationId)
        .get();

    if (medication.exists) {
      final data = medication.data()!;
      setState(() {
        nameController.text = data['name'] ?? '';
        dosageController.text = data['dosage'] ?? '';
        selectedMedicineType = data['type'] ?? '';
        selectedInterval = data['interval'] ?? 0;
        selectedTime = TimeOfDay(
          hour: int.parse(data['time'].split(':')[0]),
          minute: int.parse(data['time'].split(':')[1]),
        );
      });
    }
  }

  void _saveMedication() async {
    if (nameController.text.isEmpty || selectedInterval == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final medicationData = {
      "name": nameController.text,
      "dosage": dosageController.text,
      "type": selectedMedicineType,
      "interval": selectedInterval,
      "time": "${selectedTime.hour}:${selectedTime.minute}",
    };

    try {
      if (widget.medicationId == null) {
        await _firestore.collection('medications').add(medicationData);
      } else {
        await _firestore
            .collection('medications')
            .doc(widget.medicationId)
            .update(medicationData);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save medication: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.medicationId == null ? 'Add Medication' : 'Edit Medication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Medicine Name'),
            ),
            TextField(
              controller: dosageController,
              decoration: InputDecoration(labelText: 'Dosage'),
            ),
            // Add medicine type, interval, and time pickers here
            ElevatedButton(
              onPressed: _saveMedication,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
