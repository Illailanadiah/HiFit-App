import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MedicationsScreen extends StatelessWidget {
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
              child: ListView.builder(
                itemCount: 5, // Replace with dynamic count
                itemBuilder: (context, index) {
                  return Slidable(
                    key: ValueKey(index),
                    startActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            // Add edit logic here
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            // Add set reminder logic here
                          },
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          icon: Icons.notifications_active,
                          label: 'Set Reminder',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            // Add delete logic here
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
                        title: Text('Medication ${index + 1}'),
                        subtitle: Text('Details for Medication ${index + 1}'),
                      ),
                    ),
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
            MaterialPageRoute(builder: (context) => SetReminderScreen()),
          );
        },
        child: Icon(Icons.notifications_active),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class SetReminderScreen extends StatelessWidget {
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: medicationController,
              decoration: InputDecoration(
                labelText: 'Select Medication',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: 'Set Time',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              onTap: () {
                // Show time picker
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((selectedTime) {
                  if (selectedTime != null) {
                    timeController.text = selectedTime.format(context);
                  }
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save reminder logic here
                Navigator.pop(context);
              },
              child: Text('Save Reminder'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
