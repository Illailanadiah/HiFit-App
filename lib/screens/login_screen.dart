import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hifit/screens/home_screen.dart';
import 'package:hifit/screens/register_screen.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Future<bool> Function() authenticateWithBiometrics;

  LoginPage({required this.authenticateWithBiometrics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _auth.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login Failed: $e')),
                  );
                }
              },
              child: Text('Login with Email & Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool authenticated = await authenticateWithBiometrics();
                if (authenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Biometric Authentication Successful')),
                  );
                  // Proceed to the home page or any authenticated action
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Biometric Authentication Failed')),
                  );
                }
              },
              child: Text('Login with Fingerprint'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
