import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hifit/medications/medicaton_model.dart';

class FirestoreService {
  final CollectionReference _medicationsRef =
      FirebaseFirestore.instance.collection('medications');

  // Add a new medication
  Future<void> addMedication(Medication medication) async {
    await _medicationsRef.add(medication.toMap());
  }

  // Get all medications
  Stream<List<Medication>> getMedications() {
    return _medicationsRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Medication.fromFirestore(doc))
        .toList());
  }

  // Update a medication
  Future<void> updateMedication(String id, Medication medication) async {
    await _medicationsRef.doc(id).update(medication.toMap());
  }

  // Delete a medication
  Future<void> deleteMedication(String id) async {
    await _medicationsRef.doc(id).delete();
  }
}
