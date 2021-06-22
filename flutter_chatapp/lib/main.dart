import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/helper/authenticate.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';

import 'package:flutter_chatapp/screens/chatroomScreen.dart';
import 'package:flutter_chatapp/screens/login.dart';
import 'package:flutter_chatapp/screens/signup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase App ${e.toString()} ");
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedin = false;
  getUserInfo() async {
    await HelperFunction.getuserloggedinsharepreference().then((value) {
      if(value != null){
        setState(() {
          isUserLoggedin = value;
        });
      }
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1f1f1f),
        // primarySwatch: ,
      ),
      home: isUserLoggedin == true ? ChatRoom() : Authenticate(),
      // home: SignUp(),
      // home: LoginScreen(),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      body: Container(
        child: Center(
          child: Image.asset(
            "asset/images/logo.png",
            height: 50.0,
          ),
        ),
      ),
    );
  }
}
