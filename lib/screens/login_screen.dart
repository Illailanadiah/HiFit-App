import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Authenticate the user using biometrics
  Future<void> _authenticate(BuildContext context) async {
    try {
      final isAuthenticated = await _auth.authenticate(
        localizedReason: 'Log in to HiFit using biometrics',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (isAuthenticated) {
        // Navigate to the home screen upon successful authentication
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showSnackbar(context, 'Authentication failed. Please try again.');
      }
    } catch (e) {
      _showSnackbar(context, 'Biometric authentication error: $e');
    }
  }

  /// Display a snackbar with the given message
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(253, 179, 213, 1), // Pink Blush background
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWelcomeText(context),
                const SizedBox(height: 20),
                Lottie.asset(
                  'assets/animation/fingerprint.json',
                  height: 150,
                ),
                const SizedBox(height: 20),
                _buildLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build the welcome text
  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome to',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color.fromRGBO(72, 169, 182, 1), // Teal Blue
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
        ),
        Text(
          'HiFit',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color.fromRGBO(72, 169, 182, 1), // Teal Blue
                fontWeight: FontWeight.bold,
                fontSize: 45,
              ),
        ),
        const SizedBox(height: 20),
        Lottie.asset(
          'assets/animation/fitness.json',
          height: 300,
        ),
      ],
    );
  }

  /// Build the biometric login button
  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _authenticate(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(119, 219, 232, 1), // Sky Blue
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: const Icon(
        Icons.fingerprint,
        color: Colors.white, // White icon color
      ),
      label: const Text(
        "Login using Fingerprint",
        style: TextStyle(
          color: Colors.white, // White text color
          fontSize: 16,
        ),
      ),
    );
  }
}
