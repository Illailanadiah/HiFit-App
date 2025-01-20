import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  String id; // Firestore document ID
  String name;
  String dosage;
  String type;
  int interval;
  String time;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.type,
    required this.interval,
    required this.time,
  });

  // Convert Medication to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'type': type,
      'interval': interval,
      'time': time,
    };
  }

  // Create Medication from Firestore snapshot
  factory Medication.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Medication(
      id: doc.id,
      name: data['name'] ?? '',
      dosage: data['dosage'] ?? '',
      type: data['type'] ?? '',
      interval: data['interval'] ?? 0,
      time: data['time'] ?? '',
    );
  }
}
