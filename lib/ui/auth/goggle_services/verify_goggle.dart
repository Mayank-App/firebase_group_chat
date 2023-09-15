import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class VerifyGoggle {
  // Google SignIn
  Future<UserCredential> signInWithGoogle() async {
    // Sign begins
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Get Authentication details
    final GoogleSignInAuthentication gAuth = await googleUser!.authentication;

    // Create credetials for the user
    final cred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    // Now let's sign in
    return await FirebaseAuth.instance.signInWithCredential(cred);
  }
}


