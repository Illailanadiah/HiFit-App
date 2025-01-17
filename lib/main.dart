import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hifit/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(HiFitApp());
}

class HiFitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HiFit',
        home: LoginScreen(),
        );
  }
}
