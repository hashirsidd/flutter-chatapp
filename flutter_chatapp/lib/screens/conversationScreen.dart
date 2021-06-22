import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/services/database.dart';

class ChatScreen extends StatefulWidget {
  String reciver;
  String chatRoomID;
  ChatScreen({required this.reciver,required this.chatRoomID});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

  Widget ChatMessages() {
    return Container();
  }

  sendMessage() 
  {
    Map<String,String> messageMap = {
      'sender': Constants.loggedInUserName,
      'message' : messageEditing.text.trim()
    }         ;
    dbMethods.getConversationMessage(widget.chatRoomID, messageMap)   ;
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
            "${widget.reciver}",
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight, // 4c5258
                        colors: [Color(0xff2f3337), Color(0xff4c5258)]),
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
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 17, color: Colors.white70),
                              hintText: 'Search user...',
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
                            if(messageEditing.text.trim() != "" ){
                              print(messageEditing.text);
                              sendMessage();
                              messageEditing.clear();

                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15, right: 16),
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
    );
  }
}

/**
decoration: BoxDecoration(
color: Color(0xff2f3337),
borderRadius: BorderRadius.circular(32),
),

    Text("😃",style: TextStyle(fontSize: 20),),
    Expanded(
    child: TextField(
    keyboardType: TextInputType.text,
    textCapitalization: TextCapitalization.sentences,
    style: TextStyle(
    color: Colors.white,
    decoration: TextDecoration.none,
    ),
    decoration: InputDecoration(
    hintStyle:
    TextStyle(fontSize: 17, color: Colors.white70),
    hintText: 'Write message..',
    border: InputBorder.none,
    focusColor: Colors.white,
    contentPadding: EdgeInsets.all(10),
    ),
    ),
    ),






    **/
