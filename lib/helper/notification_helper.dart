import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification plugin with settings
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap, // Updated callback
    );
  }

  /// Handle notification tap actions
  static Future<void> _onNotificationTap(NotificationResponse response) async {
    final String? payload = response.payload;
    if (payload != null) {
      final Uri url = Uri.parse(payload);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $payload';
      }
    }
  }

  /// Schedule a notification
  static Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime, {
    String? payload, // URL or other data to pass when tapped
    String channelId = 'default_channel',
    String channelName = 'Default Notifications',
    String channelDescription = 'General notifications',
    Importance importance = Importance.high,
    Priority priority = Priority.high,
    Duration? snoozeDuration,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: importance,
          priority: priority,
        ),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Optionally schedule a snooze notification
    if (snoozeDuration != null) {
      await scheduleNotification(
        id + 1000, // Use a different ID for the snooze notification
        'Snooze: $title',
        'Reminder: $body',
        scheduledTime.add(snoozeDuration),
        payload: payload,
        channelId: channelId,
        channelName: channelName,
        channelDescription: channelDescription,
        importance: importance,
        priority: priority,
      );
    }
  }

  /// Cancel a specific notification by ID
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Show an immediate notification
  static Future<void> showInstantNotification(
    int id,
    String title,
    String body, {
    String? payload,
    String channelId = 'default_channel',
    String channelName = 'Default Notifications',
    String channelDescription = 'General notifications',
    Importance importance = Importance.high,
    Priority priority = Priority.high,
  }) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: importance,
          priority: priority,
        ),
      ),
      payload: payload,
    );
  }

  /// Reschedule a notification for a new time
  static Future<void> rescheduleNotification(
    int id,
    String title,
    String body,
    DateTime newScheduledTime, {
    String? payload,
    String channelId = 'default_channel',
    String channelName = 'Default Notifications',
    String channelDescription = 'General notifications',
    Importance importance = Importance.high,
    Priority priority = Priority.high,
  }) async {
    await cancelNotification(id);
    await scheduleNotification(
      id,
      title,
      body,
      newScheduledTime,
      payload: payload,
      channelId: channelId,
      channelName: channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
    );
  }

  /// Check pending notifications (for debugging purposes)
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }
}
