import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';
import 'package:flutter_chatapp/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserId? _userFromFirebaseUser(User user) {
    return user != null ? UserId(userId: user.uid) : null;
  }

  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(

          email: email, password: password);
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword({required String email, required String password}) async {
    email = email.trim();
    password = password.trim();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? firebaseUser = result.user;
      print(firebaseUser)     ;
      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      Constants.loggedInUserEmail = "";
      Constants.loggedInUserName = "";
      HelperFunction.saveuserloggedinsharepreference(false);
      HelperFunction.saveuseremailsharepreference("");
      HelperFunction.saveusernamesharepreference("");
      HelperFunction.saveuseridsharepreference("");

      return Constants.isGoogleUser ? await GoogleSignIn().signOut() : await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    return authResult.user;
  }
}
