import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hifit/components/uihelper.dart';
import 'package:hifit/screens/profile_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String gender = '';

  Future<void> signUp() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        gender.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty) {
      UiHelper.CustomAlertBox(context, "Please fill in all required fields");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Store user information in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'age': int.parse(ageController.text),
        'gender': gender,
        'height': int.parse(heightController.text),
        'weight': int.parse(weightController.text),
        'uid': userCredential.user!.uid,
      });

      // Navigate to ProfilePage
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(userId: userCredential.user!.uid)),
      );
    } on FirebaseAuthException catch (ex) {
      UiHelper.CustomAlertBox(context, ex.message ?? "An error occurred");
    } catch (e) {
      UiHelper.CustomAlertBox(context, "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UiHelper.CustomTextField(
                nameController,
                "Name",
                Icons.person,
                false,
                TextInputType.text,
                false,
              ),
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
                Icons.lock,
                true,
                TextInputType.text,
                true,
              ),
              UiHelper.CustomTextField(
                ageController,
                "Age",
                Icons.date_range,
                false,
                TextInputType.number,
                false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  const Text('Male'),
                  Radio(
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  const Text('Female'),
                ],
              ),
              UiHelper.CustomTextField(
                heightController,
                "Height (cm)",
                Icons.height,
                false,
                TextInputType.number,
                false,
              ),
              UiHelper.CustomTextField(
                weightController,
                "Weight (kg)",
                Icons.line_weight,
                false,
                TextInputType.number,
                false,
              ),
              const SizedBox(height: 30),
              UiHelper.CustomButton(
                signUp,
                "Sign Up",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
