import 'package:flutter/material.dart';
import 'package:flutter_chatapp/screens/login.dart';
import 'package:flutter_chatapp/screens/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    
    if (showSignIn) {
      return Signin(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}