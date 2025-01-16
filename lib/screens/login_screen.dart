import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hifit/components/uihelper.dart';
import 'package:hifit/screens/home_screen.dart';
import 'package:hifit/screens/signup_screen.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();

  /// Method for logging in with email and password
  Future<void> login(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    UiHelper.CustomAlertBox(context, "Enter Required Fields");
    return;
  }

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    
    if (userCredential.user != null) {
      debugPrint("Login successful: Navigating to HomeScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  } on FirebaseAuthException catch (ex) {
    UiHelper.CustomAlertBox(context, ex.message ?? "Login error occurred.");
  }
}


  /// Method for fingerprint authentication
  Future<void> authenticateWithFingerprint() async {
    try {
      // Check if biometric authentication is available
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        UiHelper.CustomAlertBox(context,
            "Biometric authentication is not available on this device.");
        return;
      }

      // Perform biometric authentication
      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate using fingerprint",
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        UiHelper.CustomAlertBox(context, "Fingerprint authentication failed");
      }
    } catch (e) {
      UiHelper.CustomAlertBox(context, "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(
            emailController,
            "Email",
            Icons.mail,
            false,
            TextInputType.emailAddress,
            false,
          ),
          UiHelper.CustomTextField(
            passwordController,
            "Password",
            Icons.password,
            true,
            TextInputType.text,
            true,
          ),
          const SizedBox(height: 30),
          UiHelper.CustomButton(() {
            login(emailController.text.trim(), passwordController.text.trim());
          }, "Login"),
          const SizedBox(height: 20),
          UiHelper.CustomButton(() {
            authenticateWithFingerprint();
          }, "Login with Fingerprint"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already Have an Account?",
                  style: TextStyle(fontSize: 16)),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
