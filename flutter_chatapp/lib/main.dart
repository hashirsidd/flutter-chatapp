import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/screens/chatroomScreen.dart';
import 'package:flutter_chatapp/screens/login.dart';
import 'package:flutter_chatapp/screens/signup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  }catch(e){
    print("Error initializing Firebase App ${e.toString()} ");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1f1f1f),
        // primarySwatch: ,

      ),
      home: ChatRoom(),
      // home: SignUp(),
      // home: LoginScreen(),
    );
  }
}
