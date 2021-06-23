import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  uploadUserInfo(userMap) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('users').add(userMap);
  }

  getUserByName(String userName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: userName)
        .get();
  }

  getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: userEmail)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  sendConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('Chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }
  getConversationMessage(String chatRoomId) async {
    return await  FirebaseFirestore.instance
        .collection('ChatRoom') .doc(chatRoomId) .collection('Chats')   .orderBy('time')
        // .where('ChatRoom' , isEqualTo: chatRoomId)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }
}
