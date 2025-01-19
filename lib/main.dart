import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hifit/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(HiFitApp());
}

class HiFitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HiFit',
        home: LoginPage(authenticateWithBiometrics: () async {
        // Provide a valid implementation for biometrics
        return false; // Default return in case biometrics are not configured 
        },),
        );
  }
}
