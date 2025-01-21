import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> _authenticate(BuildContext context) async {
    try {
      final isAuthenticated = await _auth.authenticate(
        localizedReason: 'Log in to HiFit using biometrics',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric authentication failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(181, 176, 179, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'HiFit',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: 20),
              Lottie.asset('assets/animation/fingerprint.json', height: 200),
              ElevatedButton.icon(
                onPressed: () => _authenticate(context),
                icon: const Icon(Icons.fingerprint, color: Color(0xFF21565C)),
                label: const Text(
                  "Login using Fingerprint",
                  style: TextStyle(color: Color(0xFF21565C)),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
