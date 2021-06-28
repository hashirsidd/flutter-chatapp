import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp/helper/authenticate.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';
import 'package:flutter_chatapp/screens/seacrh.dart';
import 'package:flutter_chatapp/services/auth.dart';
import 'package:flutter_chatapp/services/database.dart';
import 'package:intl/intl.dart';
import 'conversationScreen.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods dbMethods = new DatabaseMethods();
  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseFirestore.instance
          .collection('users').doc(Constants.loggedInUserEmail)
          .update({
        'status': "Online",
      }) ;

    } else {
      String date = "";

      DateTime dateToday = DateTime.parse(DateTime.now().toString());
      date = DateFormat.jm().format(dateToday).toString();

      FirebaseFirestore.instance
          .collection('users')
          .doc(Constants.loggedInUserEmail).update({
        'status': "Last seen $date",
      });
    }
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
        onPressed: () async {
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
          child: Column(children: [
        Chats(),
      ])),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize:  MainAxisSize.min,
                  children: <Widget>[
                  Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Color(0xff1f1f1f),
                      borderRadius: BorderRadius.circular(60)),
                  child: Center(
                    child: Text(
                        "${Constants.loggedInUserName.substring(0, 1)}${Constants.loggedInUserName.split(" ")[0].substring(Constants.loggedInUserName.split(" ")[0].length - 1)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:27 ,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w300)),
                  ),
                ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${Constants.loggedInUserName}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'OverpassRegular',

                                  color: Colors.white,
                                  fontSize: 35.0),
                            ),
                            // SizedBox(height: 5.0),
                            Text(
                              '${Constants.loggedInUserEmail}',
                              style: TextStyle(
                                  fontFamily: 'OverpassRegular',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
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
                  String date = "";

                  DateTime dateToday =
                      DateTime.parse(DateTime.now().toString());
                  date = DateFormat.jm().format(dateToday).toString();

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(Constants.loggedInUserEmail).update({
                    'status': "Last seen $date",
                  });
                  authMethods.signOut();
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

  getUserInfo() async {
    Constants.loggedInUserName =
        await HelperFunction.getusernamesharepreference();
    Constants.loggedInUserEmail =
        await HelperFunction.getuseremailsharepreference();

  }
}

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final Stream<QuerySnapshot> snapshot =
      DatabaseMethods().getChats(Constants.loggedInUserEmail);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ChatRoom')
            .where('emails', arrayContains: Constants.loggedInUserEmail)
            .orderBy('time', descending: true)
            .snapshots(includeMetadataChanges: true),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          }
          return Expanded(
            child: ClipRect(
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String recipientEmail =
                      Constants.loggedInUserEmail != data['emails'][0]
                          ? data['emails'][0]
                          : data['emails'][1];
                  String recipientName =
                      Constants.loggedInUserName != data['users'][0]
                          ? data['users'][0]
                          : data['users'][1];
                  String chatRoomId = data['chatRoomId'];
                  String message = data['lastMessage'];
                  int unread = 0;
                  unread = data['unRead'];
                  String date = "";

                  if (data['time'] != null) {
                    DateTime fullDate =
                        DateTime.parse(data['time'].toDate().toString());

                    DateTime dateToday =
                        DateTime.parse(DateTime.now().toString());
                    if (date ==
                        DateFormat.MMMd().format(dateToday).toString()) {
                      date = DateFormat.MMMd().format(fullDate).toString();
                    } else {
                      date = DateFormat.jm().format(fullDate).toString();
                    }
                  }
                  //      return Container();
                  return new MessageTile(
                    userName: recipientName,
                    chatRoomId: chatRoomId,
                    message: message,
                    date: date,
                    sender: data['lastMessageSendBy'],
                    isRead: data['isRead'],
                    unread: unread,
                    recipientEmail: recipientEmail,
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}

class MessageTile extends StatefulWidget {
  final String userName;
  final String message;
  final String chatRoomId;
  final String date;
  final String sender;
  final bool isRead;
  final int unread;
  final String recipientEmail;
  MessageTile({
    required this.userName,
    required this.chatRoomId,
    required this.message,
    required this.date,
    required this.sender,
    required this.isRead,
    required this.unread,
    required this.recipientEmail,
  });

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.isRead == false) {
              if (Constants.loggedInUserName != widget.sender) {
                FirebaseFirestore.instance
                    .collection('ChatRoom')
                    .doc(widget.chatRoomId)
                    .update({'isRead': true, 'unRead': 0}).then((value) {});
              }
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          reciver: widget.userName,
                          chatRoomID: widget.chatRoomId, recipientEmail: widget.recipientEmail,
                        )));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                        "${widget.userName.substring(0, 1)}${widget.userName.substring(widget.userName.length - 1)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w300)),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white24,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.userName.trim(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'OverpassRegular',
                                      fontWeight: FontWeight.w500)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(widget.message.trim(),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 16,
                                      fontFamily: 'OverpassRegular',
                                      fontWeight: FontWeight.w300)),
                            ],
                          ),
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(widget.date.trim(),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300)),
                            widget.userName == widget.sender
                                ? widget.isRead == false
                                    ? Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: Text(
                                          widget.unread.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )),
                                      )
                                    : Container()
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
