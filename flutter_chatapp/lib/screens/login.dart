import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';
import 'package:flutter_chatapp/screens/signup.dart';
import 'package:flutter_chatapp/services/auth.dart';
import 'package:flutter_chatapp/services/database.dart';
import 'package:flutter_chatapp/widget.dart';

import 'chatroomScreen.dart';

class Signin extends StatefulWidget {
  final Function toggle;
  Signin(this.toggle);
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final formkey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  FocusNode passwordFocus = FocusNode();
  bool isLoading = false;
  QuerySnapshot? userInfo;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods dbMethods = new DatabaseMethods();

  signIn() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signInWithEmail(emailTextEditingController.text.trim(),
              passwordTextEditingController.text.trim())
          .then((val) {
        if (val != null) {
          dbMethods
              .getUserByEmail(emailTextEditingController.text.trim())
              .then((value) {
            if(value != null){
              userInfo = value;
              Map<String, dynamic> data =
              userInfo!.docs[0].data() as Map<String, dynamic>;
              HelperFunction.saveuserloggedinsharepreference(true);
              HelperFunction.saveusernamesharepreference(data['name']);
              HelperFunction.saveuseremailsharepreference(data['email']);
              Constants.loggedInUserName = data['name'];
                  // print( "username : ${Constants.loggedInUserName }") ;
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ChatRoom()));
            }
          });

        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: isLoading
          ? Scaffold(
        backgroundColor: Color(0xff1f1f1f),
            body: Center(
                child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: CircularProgressIndicator(),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      "Signing in..",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              )),
          )
          : Scaffold(
              // appBar: MyAppBar(),
              body: SafeArea(
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
                                  "Sign in",
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
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "This field is required";
                                      } else if (EmailValidator.validate(val) ==
                                          false) {
                                        return "Enter valid email address";
                                      }
                                    },
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration:
                                        inputFieldDecoration(hint: "Email"),
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(passwordFocus);
                                    },
                                    controller: emailTextEditingController,
                                  ),
                                  TextFormField(
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "This field is required";
                                        }
                                      },
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      obscureText: true,
                                      focusNode: passwordFocus,
                                      controller: passwordTextEditingController,
                                      decoration: inputFieldDecoration(
                                          hint: "Password")),
                                ],
                              ),
                            ),
                            SizedBox(height: 18),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forget Password",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 18),
                            // signin button
                            GestureDetector(
                              onTap: () {
                                signIn();
                              },
                              child: longButton(
                                bgColor: Color(0xff2c69e1),
                                textColor: Colors.white,
                                text: "Sign In ",
                              ),
                            ),
                            SizedBox(height: 18),
                            // signin with google
                            longButton(
                              bgColor: Colors.white,
                              textColor: Color(0xff2c69e1),
                              text: "Sign In with Google",
                            ),
                            SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print("going to Signup");
                                    widget.toggle();
                                    // Navigator.pushReplacement(
                                    //     context, MaterialPageRoute(builder: (context) => SignUp()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, right: 10, bottom: 10),
                                    child: Text(
                                      "Register now",
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
  //
  // Widget field(Size size, String hint, IconData icon) {
  //   return Container(
  //     margin: EdgeInsets.only(top: size.height/20),
  //     height: size.height / 10,
  //     width: size.width / 1.2,
  //     child: TextField(
  //       decoration: InputDecoration(
  //         prefixIcon: Icon(icon) ,
  //         hintText: hint,
  //         hintStyle: TextStyle(
  //           color: Colors.black45,
  //         ),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
