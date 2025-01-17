import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // User canceled the sign-in
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('Error signing in with Google: $e');
    return null;
  }
}

Future<void> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  } catch (e) {
    print('Error signing out: $e');
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentUser == null
          ? Center(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  iconSize: 40,
                  icon: Image.asset(
                    'assets/images/google_icon.png',
                  ),
                  onPressed: () async {
                    UserCredential? credential = await signInWithGoogle();
                    if (credential != null) {
                      setState(() {
                        currentUser = credential.user;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Google Sign-In failed!'),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      currentUser!.photoURL ?? '',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentUser!.displayName ?? 'No Name',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentUser!.email ?? 'No Email',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await signOutFromGoogle();
                      setState(() {
                        currentUser = null;
                      });
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }
}
