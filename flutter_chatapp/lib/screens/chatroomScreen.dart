import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,

      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(child: Center(
          child: Text("Hello Chat room!!"),
        ),),
      ),
    );
  }
}
