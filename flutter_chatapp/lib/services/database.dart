import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  uploadUserInfo(userMap,String email) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('users').doc(email).set(userMap);
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

  sendConversationMessage(String chatRoomId, messageMap, String message, time,String messageBy) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('Chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
    FirebaseFirestore.instance.collection('ChatRoom').doc(chatRoomId).update({
      "lastMessage": message,
      "lastMessageSendBy" : messageBy,
      "time": FieldValue.serverTimestamp(),
      "chatTime": time,
      'isRead': false,
      'unRead' : FieldValue.increment(1)
    }).catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessage(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('Chats')
        .orderBy('time')
        .limitToLast(1)
        .get();
  }

  getChats(String userEmail) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('emails', arrayContains: userEmail)
        .orderBy('time')
        .snapshots(includeMetadataChanges: true);
  }
}
