import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp/helper/constants.dart';
import 'package:flutter_chatapp/helper/helperFunction.dart';
import 'package:flutter_chatapp/screens/conversationScreen.dart';
import 'package:flutter_chatapp/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget.dart';

class SearchScreen extends StatefulWidget {
  String roomuserEmail = "";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  DatabaseMethods dbMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();

  QuerySnapshot? searchSnapshot;
  initiateSearch() async {
    FocusScope.of(context)
        .requestFocus(new FocusNode());
    await dbMethods
        .getUserByName(searchEditingController.text.trim())
        .then((val) {
      searchSnapshot = val;
      setState(() {});
    });
  }

  String CurrentUser = Constants.loggedInUserName;
  sendUserToChatRoom(String userName) {
    List<String> users = [userName, CurrentUser];
    dbMethods.createChatRoom(users[0], users[1]);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
    };
  }

  sendMessage(String userName, String roomUserEmail) {
    if (roomUserEmail != Constants.loggedInUserEmail) {
      List<String> users = [Constants.loggedInUserName, userName];

      String chatRoomId =
          getChatRoomId(Constants.loggedInUserEmail, roomUserEmail);

      print(" message : $users  $chatRoomId");
      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId": chatRoomId,
      };

      dbMethods.createChatRoom(chatRoomId, chatRoom);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                  // chatRoomId: chatRoomId,
             reciver: userName, chatRoomID: chatRoomId,
              )));
    } else {
      print("Cant send message");
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight, // 4c5258
                        colors: [Color(0xff2f3337), Color(0xff4c5258)]),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (val) {
                            initiateSearch();
                          },
                          controller: searchEditingController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 17, color: Colors.white70),
                            hintText: 'Search user...',
                            border: InputBorder.none,
                            focusColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 26),
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Icon(Icons.search, color: Colors.white)),
                    ],
                  ),
                ),
                searchList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? Expanded(
            child: ListView.builder(
                itemCount: searchSnapshot!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = searchSnapshot!.docs[index].data()
                      as Map<String, dynamic>;
                  return SearchTile(data['name'], data['email']);
                }),
          )
        : Container();
  }

  Widget SearchTile(String uname, String uemail) {
    bool visible = true;
    if(uemail == Constants.loggedInUserEmail){
      visible =  false;
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$uname",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "$uemail",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            visible? GestureDetector(
              onTap: () {
                widget.roomuserEmail = uemail;
                sendMessage(uname, uemail);
                // print(Constants.loggedInUserName);
              },
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Message",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  height: 50,
                  width: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight, // 4c5258
                        colors: [Colors.blueAccent, Colors.blue]),
                    borderRadius: BorderRadius.circular(40),
                  )),
            ): Container(),
          ],
        ),
      ),
    );
  }
}
