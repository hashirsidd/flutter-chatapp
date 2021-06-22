import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';
import 'package:flutter_chatapp/screens/chatroomScreen.dart';
import 'package:flutter_chatapp/services/auth.dart';
import 'package:flutter_chatapp/services/database.dart';

import '../widget.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String password = "";
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode password2Focus = FocusNode();
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods dbMethods = new DatabaseMethods();
  signMeUp() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((value) {
        // print("${value.userId}");
        Map<String, String> userMap = {
          "name": userNameTextEditingController.text.trim(),
          'email': emailTextEditingController.text.trim()
        };
        dbMethods.uploadUserInfo(userMap);
        HelperFunction.saveuserloggedinsharepreference(true);
        HelperFunction.saveusernamesharepreference(
            userNameTextEditingController.text.trim());
        HelperFunction.saveuseremailsharepreference(
            emailTextEditingController.text.trim());
        Constants.loggedInUserName = userNameTextEditingController.text.trim();
        Constants.loggedInUserEmail = emailTextEditingController.text.trim();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }


  final formkey = GlobalKey<FormState>();
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
        body: isLoading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: CircularProgressIndicator(),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      "Signing Up..",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ))
            : SafeArea(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                            Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  TextFormField(
                                      // onSubmitted:(){},
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "This field is required";
                                        } else if (val.length <= 4) {
                                          return "Username must be atleast 5 characters";
                                        }
                                      },
                                      onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(emailFocus);
                                      },
                                      controller: userNameTextEditingController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: inputFieldDecoration(
                                          hint: "Username")),
                                  TextFormField(
                                      focusNode: emailFocus,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "This field is required";
                                        } else if (EmailValidator.validate(
                                                val) ==
                                            false) {
                                          return "Enter valid email address";
                                        }
                                      },
                                      onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(passwordFocus);
                                      },
                                      controller: emailTextEditingController,
                                      keyboardType: TextInputType.emailAddress,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration:
                                          inputFieldDecoration(hint: "Email")),
                                  TextFormField(
                                      focusNode: passwordFocus,
                                      obscureText: true,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "This field is required";
                                        } else if (val.contains(' ')) {
                                          return "Can not use space";
                                        } else if (val.length < 6) {
                                          return "Password must have 6 characters ";
                                        } else {
                                          password = val;
                                        }
                                      },
                                      onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(password2Focus);
                                      },
                                      controller: passwordTextEditingController,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: inputFieldDecoration(
                                          hint: "Password")),
                                  TextFormField(
                                      focusNode: password2Focus,
                                      obscureText: true,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "This field is required";
                                        } else if (val != password) {
                                          return "Passwords do not match";
                                        }
                                      },
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: inputFieldDecoration(
                                          hint: "Confirm Password")),
                                ],
                              ),
                            ),
                            SizedBox(height: 18),
                            SizedBox(height: 18),
                            // signin button
                            GestureDetector(
                              onTap: () {
                                signMeUp();
                              },
                              child: longButton(
                                bgColor: Color(0xff2c69e1),
                                textColor: Colors.white,
                                text: "Sign Up ",
                              ),
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
                                GestureDetector(
                                  onTap: () {
                                    widget.toggle();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 10, bottom: 10),
                                    child: Text(
                                      "Sign In now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
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
