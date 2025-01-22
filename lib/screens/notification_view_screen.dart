import 'package:flutter/material.dart';
import 'package:hifit/helper/notification_helper.dart';

class NotificationViewScreen extends StatefulWidget {
  const NotificationViewScreen({Key? key}) : super(key: key);

  @override
  _NotificationViewScreenState createState() => _NotificationViewScreenState();
}

class _NotificationViewScreenState extends State<NotificationViewScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final pendingNotifications = await NotificationHelper.getPendingNotifications();
    setState(() {
      notifications = pendingNotifications
          .map((notification) => {
                'id': notification.id,
                'title': notification.title,
                'body': notification.body,
                'payload': notification.payload ?? '',
              })
          .toList();
    });
  }

  Future<void> _cancelNotification(int id) async {
    await NotificationHelper.cancelNotification(id);
    await _fetchNotifications();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification $id has been canceled.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF48a9b6), // Teal Blue
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No scheduled notifications.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFfdb3d5), // Pink Blush
                ),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  color: const Color(0xFF77dbe8), // Sky Blue
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      notification['title'] ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text
                      ),
                    ),
                    subtitle: Text(
                      notification['body'] ?? 'No Body',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF21565C), // Deep Blue
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFFfdb3d5)), // Pink Blush
                      onPressed: () => _cancelNotification(notification['id']),
                    ),
                    onTap: () {
                      if (notification['payload'].isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Notification Details',
                              style: TextStyle(
                                color: Color(0xFF48a9b6), // Teal Blue
                              ),
                            ),
                            content: Text(
                              'Payload: ${notification['payload']}',
                              style: const TextStyle(
                                color: Color(0xFF21565C), // Deep Blue
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Color(0xFFfdb3d5), // Pink Blush
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
