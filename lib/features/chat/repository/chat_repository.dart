// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_cl/models/chat_contact_model.dart';
import 'package:whatsapp_cl/models/messsage_model.dart';
import 'package:whatsapp_cl/models/user_model.dart';
import 'package:whatsapp_cl/utils/common_firebase_storage_repository.dart';
import 'package:whatsapp_cl/utils/message_enum.dart';
import 'package:whatsapp_cl/utils/utils.dart';
import 'package:path/path.dart' as p;

final chatRepositoryProvider = Provider((ref) => ChatRepository(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    ));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({
    required this.firestore,
    required this.firebaseAuth,
  });

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel? recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
    bool isGroupChat,
  ) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
// users -> reciever user id => chats -> current user id -> set data
      var recieverChatContact = ChatContactModel(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        lastMessageTime: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .set(
            recieverChatContact.toMap(),
          );
      // users -> current user id  => chats -> reciever user id -> set data
      var senderChatContact = ChatContactModel(
        name: recieverUserData!.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        lastMessageTime: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(
            senderChatContact.toMap(),
          );
    }
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    // required MessageReply? messageReply,
    required String senderUsername,
    required String? recieverUserName,
    required bool isGroupChat,
  }) async {
    final message = MessageModel(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: recieverUserId,
      text: text,
      type: messageType,
      timeStamp: timeSent,
      messageId: messageId,
      isSeen: false,
      // repliedMessage: messageReply == null ? '' : messageReply.message,
      // repliedTo: messageReply == null
      //     ? ''
      //     : messageReply.isMe
      //         ? senderUsername
      //         : recieverUserName ?? '',
      // repliedMessageType:
      //     messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    if (isGroupChat) {
      // groups -> group id -> chat -> message
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
      // users -> eciever id  -> sender id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    }
  }

  void sendMessage({
    required BuildContext context,
    required String text,
    required String receiveUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeStamp = DateTime.now();
      UserModel receiveUser =
          await firestore.collection('users').doc(receiveUserId).get().then(
                (value) => UserModel.fromMap(
                  value.data()!,
                ),
              );
      _saveDataToContactsSubcollection(
        senderUser,
        receiveUser,
        text,
        timeStamp,
        receiveUserId,
        false,
      );
      var messageId = const Uuid().v1();
      _saveMessageToMessageSubcollection(
        recieverUserId: receiveUserId,
        text: text,
        timeSent: timeStamp,
        messageId: messageId,
        username: senderUser.name,
        messageType: MessageEnum.text,
        senderUsername: senderUser.name,
        recieverUserName: receiveUser.name,
        isGroupChat: false,
      );
    } catch (e) {
      showSnackbar(
        context: context,
        content: e.toString(),
      );
    }
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> chatContacts = [];
      for (var document in event.docs) {
        var contact = ChatContactModel.fromMap(document.data());
        var userData =
            await firestore.collection('users').doc(contact.contactId).get();

        var user = UserModel.fromMap(userData.data()!);
        chatContacts.add(
          ChatContactModel(
            name: user.name,
            profilePic: user.profilePic,
            lastMessage: contact.lastMessage,
            lastMessageTime: contact.lastMessageTime,
            contactId: contact.contactId,
          ),
        );
      }
      return chatContacts;
    });
  }

  Stream<List<MessageModel>> getChatStream(String userId) {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timeStamp')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(MessageModel.fromMap(document.data()));
      }
      return messages;
    });
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      var fileUrl =
          await ref.read(commonFirebaseStorageRepositoryProvider).uploadImage(
                path:
                    'chat/${messageEnum == MessageEnum.image ? 'image' : messageEnum == MessageEnum.audio ? 'audio' : messageEnum == MessageEnum.video ? 'video' : messageEnum == MessageEnum.gif ? 'gif' : 'text'}/${senderUserData.uid}/$receiverUserId/$messageId',
                fileName: p.basename(file.path),
                image: file,
              );
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = '🎬 Gif';
          break;
        default:
          contactMsg = '🎬 Gif';
      }

      _saveDataToContactsSubcollection(
        senderUserData,
        receiverUserData,
        contactMsg,
        timeSent,
        receiverUserId,
        false,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: receiverUserId,
        text: fileUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        messageType: messageEnum,
        senderUsername: senderUserData.name,
        recieverUserName: receiverUserData.name,
        isGroupChat: false,
      );
    } catch (e) {
      showSnackbar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
