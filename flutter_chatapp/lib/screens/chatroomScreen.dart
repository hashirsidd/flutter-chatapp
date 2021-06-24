import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp/helper/authenticate.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';
import 'package:flutter_chatapp/screens/seacrh.dart';
import 'package:flutter_chatapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatapp/services/database.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'conversationScreen.dart';
import 'login.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods dbMethods = new DatabaseMethods();

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    getChats(Constants.loggedInUserEmail);
    super.initState();
  }

  getUserInfo() async {
    Constants.loggedInUserName =
        await HelperFunction.getusernamesharepreference();
    Constants.loggedInUserEmail =
        await HelperFunction.getuseremailsharepreference();
  }

  QuerySnapshot? snapshot;
  getChats(String userEmail) async {
    await dbMethods.getChats(userEmail).then((val) {
      print("Getting chats...");
      setState(() {
        snapshot = val;
        print(snapshot!.docs.length);
      });
    });
  }

  QuerySnapshot? messageSnapshot;
  getMessages(chatRoomId) async {
    await dbMethods.getConversationMessage(chatRoomId).then((val) {
      messageSnapshot = val;
    });
  }

  Widget chats() {
    return snapshot != null
        ? Container(
            child: ListView.builder(
                itemCount: snapshot!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      snapshot!.docs[index].data() as Map<String, dynamic>;
                  print("hereee ${snapshot!.docs.length}");
                  print(snapshot!.docs[index].data());
                  String recipientEmail =
                      Constants.loggedInUserEmail != data['emails'][0]
                          ? data['emails'][0]
                          : data['emails'][1];
                  String recipientName =
                      Constants.loggedInUserName != data['users'][0]
                          ? data['users'][0]
                          : data['users'][1];
                  String chatRoomId = data['chatRoomId'];
                  dbMethods.getConversationMessage(chatRoomId).then((val) {
                    QuerySnapshot messages = val;
                    print(messages.docs[0].data());

                  });

                  return MessageTile(
                      userName: recipientName,
                      chatRoomId: chatRoomId,
                      userEmail: recipientEmail);
                }),
          )
        : Container();
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
          
          },
        child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight, // 4c5258
                  colors: [Colors.blueAccent, Colors.blue]),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(Icons.add)),
      ),
      body: SafeArea(
        child: chats(),
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
                      end: Alignment.topRight, // 4c5258
                      colors: [Colors.blueAccent, Colors.blue]),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://www.habitattbay.com/wp-content/uploads/user-account-icon_82574.png'),
                      radius: 40.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${Constants.loggedInUserName.split(" ")[0]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '${Constants.loggedInUserEmail}',
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                title: Text('Settings',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
                onTap: () {},
              ),
              Divider(
                height: 3.0,
                color: Colors.white54,
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                title: Text('Sign out',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
                onTap: () {
                  authMethods.signOut();
                  print("Sign out ");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Authenticate()));
                },
              ),
              Divider(
                height: 3.0,
                color: Colors.white54,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  leading: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  title: Text('Close App',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                  onTap: () {
                    // Here you can give your route to navigate
                    final snackBar = SnackBar(
                      content: Text('Exiting App!'),
                      elevation: 50,
                      action: SnackBarAction(
                        label: 'Cancel',
                        onPressed: () {},
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

class MessageTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String chatRoomId;

  MessageTile(
      {required this.userName,
      required this.chatRoomId,
      required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      reciver: userName,
                      chatRoomID: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40)),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.habitattbay.com/wp-content/uploads/user-account-icon_82574.png'),
                radius: 40.0,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
