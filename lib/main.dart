import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hifit/medications/add_medication.dart';
import 'package:hifit/screens/home_screen.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/home': (context) => HomeScreen(),
        '/biometric_login': (context) => BiometricLoginScreen(),
        '/add_medication': (context) => AddMedicationScreen(),
      },
    );
  }
}

/// AuthWrapper to determine the starting screen
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // User is logged in
          return HomeScreen();
        } else {
          // User is not logged in
          return BiometricLoginScreen();
        }
      },
    );
  }
}
