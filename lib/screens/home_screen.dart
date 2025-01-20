import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

   final user=FirebaseAuth.instance.currentUser;

   signOut()async{
     await FirebaseAuth.instance.signOut();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text( '${user!.email}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (()=>signOut()),
        child: Icon(Icons.logout),
      ),
    );
  }
}