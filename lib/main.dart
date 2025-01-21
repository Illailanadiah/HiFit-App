import 'package:flutter/material.dart';
import 'package:hifit/helper/notification_helper.dart';
import 'package:hifit/screens/home_screen.dart';
import 'package:hifit/screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  await Permission.notification.request();

  runApp(const HiFitApp());
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (status != PermissionStatus.granted) {
    print('Notification permission denied');
  }
}

class HiFitApp extends StatelessWidget {
  const HiFitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HiFit',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
