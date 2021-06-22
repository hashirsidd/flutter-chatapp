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
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20),
        //     child: GestureDetector(
        //       onTap: () {
        //         authMethods.signOut();
        //         print("Sign out ");
        //         Navigator.pushReplacement(context,
        //             MaterialPageRoute(builder: (context) => Authenticate()));
        //       },
        //       child: Center(
        //         child: Row(
        //           children: [
        //             Text(
        //               "Sign out",
        //               style: TextStyle(
        //                 fontSize: 16,
        //               ),
        //             ),
        //             Icon(Icons.exit_to_app),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
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
          child: Column(
            children: [
              Text("Hello ${Constants.loggedInUserName}",
              style: TextStyle(
                color: Colors.white,
              ),),

            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        elevation: 10.0,

        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff1f1f1f),
          ),
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(

                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,               // 4c5258
                      colors: [Colors.blueAccent, Colors.blue]),
                  // color: Color(0xff2f3337),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://www.habitattbay.com/wp-content/uploads/user-account-icon_82574.png'),
                      radius: 40.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${Constants.loggedInUserName.split(" ")[0]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25.0
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text('${Constants.loggedInUserEmail}',
                          style: TextStyle(
                              
                              color: Colors.white,
                              fontSize: 14.0
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings,color: Colors.white,),
                title: Text('Settings', style: TextStyle(fontSize: 18,color: Colors.white,)),
                onTap: () {
                },
              ),
              //Here you place your menu items

              Divider(height: 3.0,color: Colors.white54,),
              ListTile(
                leading: Icon(Icons.exit_to_app,color: Colors.white,),
                title: Text('Sign out', style: TextStyle(fontSize: 18,color: Colors.white,)),
                onTap: () {
                  authMethods.signOut();
                  print("Sign out ");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Authenticate()));

                },
              ),
              Divider(height: 3.0,color: Colors.white54,),

              Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  leading: Icon(Icons.close,color: Colors.white,),
                  title: Text('Close App', style: TextStyle(fontSize: 18,color: Colors.white,)),
                  onTap: () {
                    // Here you can give your route to navigate
                    final snackBar = SnackBar(
                      content: Text('Yay! A SnackBar!'),
                      elevation: 50,
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  }

