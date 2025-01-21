import 'package:flutter/material.dart';
import 'package:hifit/helper/database_helper.dart';

class FitnessRecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fitness Recommendation')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.fetchMedications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No medications to base recommendations on.'));
          }

          final medications = snapshot.data!;
          return ListView.builder(
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final med = medications[index];
              return ListTile(
                title: Text('Workout Plan for ${med['name']}'),
                subtitle: Text('Suggested: Light Yoga or Walking'),
              );
            },
          );
        },
      ),
    );
  }
}
