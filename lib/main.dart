import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hifit/screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
// Initialize Firebase
  runApp(HiFitApp());
}

class HiFitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HiFit',
      home: Wrapper(),
    );
  }
}
