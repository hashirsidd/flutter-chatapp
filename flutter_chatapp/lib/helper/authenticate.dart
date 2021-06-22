import 'package:flutter/material.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';
import 'package:flutter_chatapp/screens/chatroomScreen.dart';
import 'package:flutter_chatapp/screens/conversationScreen.dart';
import 'package:flutter_chatapp/screens/login.dart';
import 'package:flutter_chatapp/screens/signup.dart';
import 'package:flutter_chatapp/helper/constants.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  bool isUserLoggedin = false;
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  getUserInfo()async{
    Constants.loggedInUserName = await HelperFunction.getusernamesharepreference() ;
    Constants.loggedInUserEmail = await HelperFunction.getuseremailsharepreference() ;
    isUserLoggedin = (await HelperFunction.getuserloggedinsharepreference())!;
                       print(isUserLoggedin);
  }
  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

   if(isUserLoggedin==false){
     if (showSignIn) {
       return Signin(toggleView);
     } else {
       return SignUp(toggleView);
     }
   }  else{
     // print(Constants.constantIsUserLoggedIn);
     return ChatRoom();

   }
  }
}
