import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';

class Authentication {
  static final _auth = LocalAuthentication();
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Check if the device supports fingerprint authentication
  static Future<bool> canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  // Perform fingerprint authentication
  static Future<bool> authenticate() async {
    try {
      if (!await canAuthenticate()) return false;
      return await _auth.authenticate(
          localizedReason: "Authenticate to access the app");
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Perform Google authentication
  static Future<GoogleSignInAccount?> loginWithGoogle() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  // Sign out from Google
  static Future<void> logoutFromGoogle() async {
    await _googleSignIn.signOut();
  }
}
