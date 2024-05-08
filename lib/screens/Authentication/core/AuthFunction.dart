
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<UserCredential> signInWithGoogle(context) async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  // Access the user's name and email
  final String displayName = userCredential.user!.displayName?? '';
  final String email = userCredential.user!.email?? '';

  // Now you can use displayName and email as needed
  print('Display Name: $displayName');
  print('Email: $email');
  

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
Future signOut() async{
  await FirebaseAuth.instance.signOut();
}