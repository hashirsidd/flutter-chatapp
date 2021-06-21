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
}