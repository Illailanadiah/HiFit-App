import 'package:flutter/material.dart';
import 'package:hifit/helper/notification_helper.dart';
import 'package:intl/intl.dart'; // For formatting the scheduled time

class MedicationReminderScreen extends StatelessWidget {
  final String medicationName = "Paracetamol";
  final String dosage = "500mg";
  final DateTime scheduledTime = DateTime.now().add(Duration(hours: 1)); // Schedule 1 hour from now

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Schedule Medication Reminder')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await NotificationHelper.scheduleNotification(
              1, // Unique ID for the notification
              "Medication Reminder",
              "It's time to take your $medicationName ($dosage).",
              scheduledTime,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Reminder set for ${DateFormat('hh:mm a').format(scheduledTime)}",
                ),
              ),
            );
          },
          child: Text('Set Reminder'),
        ),
      ),
    );
  }
}
