import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/screens/chatroomScreen.dart';
import 'package:flutter_chatapp/services/database.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  String reciver;
  String chatRoomID;
  String recipientEmail;
  ChatScreen(
      {required this.reciver,
      required this.chatRoomID,
      required this.recipientEmail});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    getMessages(widget.chatRoomID);

    super.initState();
  }

  String userStatus = "";
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  DatabaseMethods dbMethods = new DatabaseMethods();
  TextEditingController messageEditing = new TextEditingController();

  sendMessage() async {
    Map<String, dynamic> messageMap = {
      'sender': Constants.loggedInUserName,
      'message': messageEditing.text.trim(),
      'time': FieldValue.serverTimestamp(),
      'seen': false,
    };
    dbMethods.sendConversationMessage(
        widget.chatRoomID,
        messageMap,
        messageEditing.text.trim(),
        DateTime.now().millisecondsSinceEpoch,
        Constants.loggedInUserName);
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.loggedInUserEmail)
        .get();

  }

  // Stream<QuerySnapshot>? chats;

  QuerySnapshot? chats;
  getMessages(chatRoomId) {
    dbMethods
        .getConversationMessage(chatRoomId)
        .then((QuerySnapshot querySnapshot) {
      chats = querySnapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Stream collectionStream = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.recipientEmail)
    //     .snapshots().listen((event) {
    //           print(event);
    // });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2f3337),
        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Color(0xff1f1f1f)),
        elevation: 2.0,
        title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.reciver}",
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.recipientEmail)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if(snapshot.data != null){
                      if (snapshot.hasError) {
                        return Text(
                          'Something went wrong',
                          style: TextStyle(fontSize: 10),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "Loading",
                          style: TextStyle(fontSize: 10),
                        );
                      }
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!['status'],
                          style: TextStyle(fontSize: 12),
                        );
                      }
                    }
                    return Container() ;
                  }),
            ],
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            offset: Offset(0, 55),
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: SizedBox(
          child: ClipRect(
            child: Column(
              children: [
                chatMessages(
                  chatId: widget.chatRoomID,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight, // 4c5258
                            colors: [Colors.blueAccent, Colors.blue]),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Form(
                              child: TextFormField(
                                controller: messageEditing,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: 17, color: Colors.white70),
                                  hintText: 'Write message...',
                                  border: InputBorder.none,
                                  focusColor: Colors.white,
                                  contentPadding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20, right: 5),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                if (messageEditing.text.trim() != "") {
                                  print(messageEditing.text);
                                  sendMessage();
                                  messageEditing.clear();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, right: 16),
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )),
                        ],
                      ),
                    ),
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

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final bool seen;
  final String date;

  MessageTile(
      {required this.message,
      required this.sendByMe,
      required this.seen,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return sendByMe
        ? Row(
            children: [
              Spacer(),
              Container(
                padding: EdgeInsets.only(top: 6, left: 0, right: 10),
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ],
                      )),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 5),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.65,
                        ),
                        child: Text(message,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300)),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10, right: 5),
                        child: Text(date,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w300)),
                      ),
                      seen != true
                          ? Container(
                              padding: EdgeInsets.only(bottom: 10, right: 10),
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.check_circle_outline_sharp,
                                color: Colors.white,
                                size: 15,
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.only(bottom: 10, right: 10),
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ],
          )
        : Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 6, left: 10, right: 0),
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(right: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0x1AFFFFFF),
                          const Color(0x1AFFFFFF)
                        ],
                      )),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 5),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.65,
                        ),
                        child: Text(message,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300)),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10, right: 10),
                        child: Text(date,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w300)),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          );
  }
}

class chatMessages extends StatefulWidget {
  final String? chatId;
  chatMessages({required this.chatId});
  @override
  _chatMessagesState createState() => _chatMessagesState();
}

class _chatMessagesState extends State<chatMessages> {
  late Stream<QuerySnapshot> _usersStream;
  int limit = 20;

 late  ScrollController _controller;
  _scrollListener() {
    // if _scroll reach top
    if (_controller.position.userScrollDirection ==
        ScrollDirection.forward) {
             print("Scroll up");
      print("000000000000000000000000000000000000000 $limit");
      _usersStream = FirebaseFirestore.instance
          .collection('ChatRoom')
          .doc(widget.chatId)
          .collection('Chats')
          .orderBy('time',descending: false).limitToLast(limit)
          .snapshots();
      setState(() {
        limit = limit + 20;

      });

    }
  }
  @override
  void initState() {
    _usersStream = FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(widget.chatId)
        .collection('Chats')
        .orderBy('time',descending: false).limitToLast(20)
        .snapshots();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        


        if (snapshot.hasData) {
          return Expanded(
            child: new ListView(
              shrinkWrap: true,
              controller: _controller,
              scrollDirection: Axis.vertical,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                if (snapshot.data!.docs.length > 0) {
                  Timer(
                      Duration(milliseconds: 0),
                      () => _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300)));
                }
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                if (Constants.loggedInUserName != data["sender"] &&
                    data['seen'] == false) {
                  FirebaseFirestore.instance
                      .collection('ChatRoom')
                      .doc(widget.chatId)
                      .collection('Chats')
                      .doc(document.id)
                      .update({
                    'seen': true,
                  });
                  FirebaseFirestore.instance
                      .collection('ChatRoom')
                      .doc(widget.chatId)
                      .update({'isRead': true, "unRead": 0});
                }
                String date = "";
                if (data['time'] != null) {
                  DateTime fullDate =
                      DateTime.parse(data['time'].toDate().toString());

                  DateTime dateToday =
                      DateTime.parse(DateTime.now().toString());
                  if (date == DateFormat.MMMd().format(dateToday).toString()) {
                    date = DateFormat.MMMd().format(fullDate).toString();
                  } else {
                    date = DateFormat.jm().format(fullDate).toString();
                  }
                }

                print(date);
                return MessageTile(
                  message: data['message'],
                  sendByMe: Constants.loggedInUserName == data["sender"],
                  seen: data['seen'],
                  date: date,
                );
              }).toList(),
            ),
          );
        }
        return Spacer();
      },
    );
  }
}
