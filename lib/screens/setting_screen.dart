import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    // Clear user session or authentication details
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored preferences

    // Navigate to login screen
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF21565C), // Deep Blue color
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.palette, color: Color(0xFFCE5100)), // Orange
            title: const Text('Theme'),
            subtitle: const Text('Change app theme'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Theme Settings'),
                  content: const Text('Choose between Light or Dark Mode'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Implement Light Theme
                        Navigator.pop(context);
                      },
                      child: const Text('Light'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement Dark Theme
                        Navigator.pop(context);
                      },
                      child: const Text('Dark'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications,
                color: Color(0xFFCE5100)), // Orange
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification settings'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Notification settings coming soon!')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock, color: Color(0xFF091819)), // Black
            title: const Text('Privacy'),
            subtitle: const Text('Privacy and security options'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings coming soon!')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.info, color: Color(0xFF21565C)), // Deep Blue
            title: const Text('About'),
            subtitle: const Text('Learn more about the app'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'HiFit App',
                applicationVersion: '1.0.0',
                applicationIcon:
                    const Icon(Icons.fitness_center, color: Color(0xFFCE5100)),
                children: const [
                  Text(
                      'HiFit is an app designed to help you manage your fitness and medications seamlessly.'),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.logout, color: Color(0xFFB5B0B3)), // Silver
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close the dialog
                        await _logout(context); // Call logout logic
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
