import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FitnessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fitness Routines')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Fitness Routines',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text('Routine ${index + 1}'),
                      subtitle: LinearPercentIndicator(
                        lineHeight: 14.0,
                        percent: 0.5,
                        backgroundColor: Colors.grey[300],
                        progressColor: Colors.green,
                      ),
                      trailing: Icon(Icons.edit, color: Colors.blue),
                      onTap: () {
                        // Edit routine logic
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
