import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/chat_contact_model.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    // users-> reciever user id-> chats -> current user id -> set data   displaying for other user
    var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(recieverChatContact.toMap());

    // users-> current user id-> chats -> reciever user id -> set data   displaying for us
    var senderChatContact = ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(senderChatContact.toMap());

    void _saveMessageToMessageSubCollection(
        {required recieverUserId,
        required String text,
        required DateTime timeSent,
        required String messageId,
        required String username,
        required String receiverUsername,
        required MessageEnum messageType,}) async {}
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    // users -> sender id -> reciever id -> messages-> message id -> store messages

    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,

        _saveMessageToMessageSubCollection();
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
