import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp/helper/authenticate.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';
import 'package:flutter_chatapp/screens/seacrh.dart';
import 'package:flutter_chatapp/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class ChatRoom extends StatefulWidget {

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    Constants.loggedInUserName = await HelperFunction.getusernamesharepreference() ;
    Constants.loggedInUserEmail = await HelperFunction.getuseremailsharepreference() ;
    // print("useremail at chatroom : ${Constants.loggedInUserEmail}");

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

         backgroundColor: Color(0xff2f3337),

        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Color(0xff1f1f1f)),
        elevation: 2.0,
        title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Chats",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                authMethods.signOut();
                print("Sign out ");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Center(
                child: Row(
                  children: [
                    Text(
                      "Sign out",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Icon(Icons.exit_to_app),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          print("Search");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        child: Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
          gradient: LinearGradient(

              begin: Alignment.bottomLeft,
              end: Alignment.topRight,               // 4c5258
              colors: [Colors.blueAccent, Colors.blue]),
          // color: Color(0xff2f3337),
          borderRadius: BorderRadius.circular(32),
        ),child: Icon(Icons.search)),
      ),
      body: SafeArea(
        child: Center(
          child: Text("Hello ${Constants.loggedInUserName}",
          style: TextStyle(
            color: Colors.white,
          ),),
        ),
      ),
    );
  }
}
