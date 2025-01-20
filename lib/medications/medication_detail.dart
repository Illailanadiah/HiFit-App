import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationDetailsScreen extends StatelessWidget {
  final String medicationId; // Pass the medication document ID from Firestore

  const MedicationDetailsScreen({Key? key, required this.medicationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          "Medication Details",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('medications').doc(medicationId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No details found for this medication."));
          }

          final medicationData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainSection(
                  medicineName: medicationData['name'] ?? "Unknown",
                  medicineType: medicationData['type'] ?? "Unknown",
                  dosage: medicationData['dosage'] ?? "Not Specified",
                ),
                SizedBox(height: 15),
                ExtendedSection(
                  interval: medicationData['interval'] ?? 0,
                  startTime: medicationData['time'] ?? "Unknown",
                ),
                SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: () {
                      _deleteMedication(context, _firestore, medicationId);
                    },
                    child: Text(
                      "Delete Medication",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
              
            ),
          );
        },
      ),
    );
  }

  void _deleteMedication(
      BuildContext context, FirebaseFirestore firestore, String docId) async {
    try {
      await firestore.collection('medications').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Medication deleted successfully.")),
      );
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete medication: $e")),
      );
    }
  }
}

class MainSection extends StatelessWidget {
  final String medicineName;
  final String medicineType;
  final String dosage;

  const MainSection({
    Key? key,
    required this.medicineName,
    required this.medicineType,
    required this.dosage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMedicineIcon(medicineType, 75),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainInfoTab(fieldTitle: "Medicine Name", fieldInfo: medicineName),
            MainInfoTab(fieldTitle: "Dosage", fieldInfo: dosage),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicineIcon(String type, double size) {
    IconData iconData;
    switch (type) {
      case "Bottle":
        iconData = Icons.local_drink;
        break;
      case "Pill":
        iconData = Icons.medication;
        break;
      case "Syringe":
        iconData = Icons.medical_services;
        break;
      case "Tablet":
        iconData = Icons.tablet;
        break;
      default:
        iconData = Icons.local_hospital;
    }
    return Icon(iconData, size: size, color: Colors.pinkAccent);
  }
}

class MainInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  const MainInfoTab({
    Key? key,
    required this.fieldTitle,
    required this.fieldInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldTitle,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFC9C9C9),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            fieldInfo,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  final int interval;
  final String startTime;

  const ExtendedSection({
    Key? key,
    required this.interval,
    required this.startTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExtendedInfoTab(
          fieldTitle: "Dose Interval",
          fieldInfo: interval == 0
              ? "Not Specified"
              : "Every $interval hours",
        ),
        ExtendedInfoTab(
          fieldTitle: "Start Time",
          fieldInfo: startTime,
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  const ExtendedInfoTab({
    Key? key,
    required this.fieldTitle,
    required this.fieldInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldTitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            fieldInfo,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFC9C9C9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
