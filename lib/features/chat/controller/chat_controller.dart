import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_cl/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_cl/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_cl/models/chat_contact_model.dart';
import 'package:whatsapp_cl/models/messsage_model.dart';
import 'package:whatsapp_cl/utils/message_enum.dart';

final chatControllerProvider = Provider(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(
      chatRepository: chatRepository,
      ref: ref,
    );
  },
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendMessage(
    BuildContext context,
    String text,
    String receiveUserId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendMessage(
            context: context,
            text: text,
            receiveUserId: receiveUserId,
            senderUser: value!,
          ),
        );
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiveUserId,
    MessageEnum messageEnum,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiveUserId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
          ),
        );
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<MessageModel>> getMessages(String receiveUserId) {
    return chatRepository.getChatStream(receiveUserId);
  }
}
