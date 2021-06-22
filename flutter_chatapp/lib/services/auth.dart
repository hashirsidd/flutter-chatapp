import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';
import 'package:flutter_chatapp/model/user.dart';

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
    password = password..trim();
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
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
