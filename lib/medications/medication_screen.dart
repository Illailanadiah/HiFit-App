import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hifit/medications/add_medication.dart';
import 'package:hifit/medications/medication_detail.dart';

class MedicationsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Medications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Medications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('medications').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No medications found.'));
                  }

                  final medications = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final medication = medications[index];
                      return Slidable(
                        key: ValueKey(medication.id),
                        startActionPane: ActionPane(
                          motion: DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Navigate to AddMedicineScreen for editing
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddMedicineScreen(
                                      medicationId: medication.id,
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                // Delete medication from Firestore
                                await _firestore
                                    .collection('medications')
                                    .doc(medication.id)
                                    .delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${medication['name']} deleted successfully.'),
                                  ),
                                );
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text(medication['name']),
                            subtitle: Text(
                                'Dosage: ${medication['dosage']}\nInterval: ${medication['interval']} hours'),
                            onTap: () {
                              // Navigate to MedicationDetailsScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicationDetailsScreen(
                                    medicationId: medication.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMedicineScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
