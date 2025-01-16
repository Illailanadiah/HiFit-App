import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hifit/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HiFitApp());
}

class HiFitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HiFit',
      home: OnboardingScreen(),
    );
  }
}
