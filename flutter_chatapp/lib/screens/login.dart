import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp/widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // late FocusNode pass;
  // late FocusNode button;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light ,
      child: Scaffold(
        // appBar: MyAppBar(),
        body: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[Container(
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("asset/images/logo.png", height: 50.0,)
                        ,
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
                    TextField(decoration: inputFieldDecoration(hint:"Email")),
                    TextField(decoration: inputFieldDecoration(hint:"Password")),

                    //     textField(
                    //   hint: "Email",
                    // ),
                    // textField(
                    //   hint: "Password",
                    // ),
                    SizedBox(height: 18),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forget Password",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 18),
                    // signin button
                    longButton(
                      bgColor: Color(0xff2c69e1),
                      textColor: Colors.white,
                      text: "Sign In ",
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
                        Text(
                          "Register now",
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
              ),],
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
