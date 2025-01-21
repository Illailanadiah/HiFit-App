import 'package:flutter/material.dart';
import 'package:hifit/helper/notification_helper.dart';
import 'package:hifit/screens/home_screen.dart';
import 'package:hifit/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  runApp(const HiFitApp());
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
