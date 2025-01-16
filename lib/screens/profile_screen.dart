import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
        ),
        body: const Center(
          child: Text('User ID is missing'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var userData = snapshot.data?.data();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Name'),
                    subtitle: Text(userData?['name'] ?? 'No data'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(userData?['email'] ?? 'No data'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cake),
                    title: const Text('Age'),
                    subtitle: Text(userData?['age']?.toString() ?? 'No data'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.transgender),
                    title: const Text('Gender'),
                    subtitle: Text(userData?['gender'] ?? 'No data'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.height),
                    title: const Text('Height (cm)'),
                    subtitle: Text(userData?['height']?.toString() ?? 'No data'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.line_weight),
                    title: const Text('Weight (kg)'),
                    subtitle: Text(userData?['weight']?.toString() ?? 'No data'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
