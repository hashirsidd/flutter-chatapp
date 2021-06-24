import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/screens/chatroomScreen.dart';
import 'package:flutter_chatapp/services/database.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  String reciver;
  String chatRoomID;
  ChatScreen({required this.reciver, required this.chatRoomID});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    getMessages(widget.chatRoomID);
    super.initState();
  }

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
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    dbMethods.sendConversationMessage(widget.chatRoomID, messageMap);
    setState(() {
      messageEditing.clear();
      getMessages(widget.chatRoomID);
    });
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff2f3337),
        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Color(0xff1f1f1f)),
        elevation: 2.0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ChatRoom()));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "${widget.reciver}",
              ),
            ),
          ],
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
                                      top: 10,
                                      bottom: 10,
                                      left: 20,
                                      right: 5),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                if (messageEditing.text.trim() != "") {
                                  print(messageEditing.text);
                                  sendMessage();
                                  // _scrollController.animateTo(
                                  //   _scrollController.position.maxScrollExtent,
                                  //   curve: Curves.easeOut,
                                  //   duration: const Duration(milliseconds: 500),
                                  // );
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

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 6, left: sendByMe ? 0 : 10, right: sendByMe ? 10 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300)),
      ),
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
  @override
  void initState() {
    _usersStream = FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(widget.chatId)
        .collection('Chats')
        .orderBy('time')
        .snapshots();
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
              // controller: _scrollController,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return MessageTile(
                  message: data['message'],
                  sendByMe: Constants.loggedInUserName == data["sender"],
                );
              }).toList(),
            ),
          );
        }
        return Spacer();

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Text("Loading");
        // }
      },
    );
  }
}

/**
Widget chatMessages(BuildContext context) {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('ChatRoom')
      .doc(wichatRoomId)
      .collection('Chats')
      .orderBy('time').snapshots();
  return StreamBuilder<QuerySnapshot>(
    stream: chats,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return snapshot.hasData
          ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            print(snapshot.data!.docs.length);
            return MessageTile(
              message: snapshot.,
              sendByMe: true,
            );
            //   return MessageTile(
            //     message: snapshot.data?.docs[index].data()!["message"],
            //     sendByMe: Constants.loggedInUserName == snapshot.data?.docs[index].data()!["sendBy"],
            //   // );
            //   // return MessageTile(
            //   //   message: data["message"],
            //   //   sendByMe: Constants.loggedInUserName == data!["sender"],
            //   // );
            // );
          })
          : Container();
    },
  );
}

    **/
