import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // appBar: MyAppBar(),
        body: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "asset/images/logo.png",
                            height: 50.0,
                          ),
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      TextField(
                          controller: userNameTextEditingController,
                          decoration: inputFieldDecoration(hint: "Username")),
                      TextField(
                          controller: emailTextEditingController,
                          decoration: inputFieldDecoration(hint: "Email")),
                      TextField( controller: passwordTextEditingController,
                          decoration: inputFieldDecoration(hint: "Password")),
                      TextField( controller: passwordTextEditingController,
                          decoration: inputFieldDecoration(hint: "Confirm Password")),

                      SizedBox(height: 18),
                      // Container(
                      //   alignment: Alignment.centerRight,
                      //   child: Text(
                      //     "Forget Password",
                      //     style: TextStyle(color: Colors.white, fontSize: 16),
                      //   ),
                      // ),
                      SizedBox(height: 18),
                      // signin button
                      longButton(
                        bgColor: Color(0xff2c69e1),
                        textColor: Colors.white,
                        text: "Sign Up ",
                      ),
                      SizedBox(height: 18),
                      // signin with google
                      longButton(
                        bgColor: Colors.white,
                        textColor: Color(0xff2c69e1),
                        text: "Sign Up with Google",
                      ),
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            "Sign In now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
