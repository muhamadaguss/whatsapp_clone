import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_cl/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_cl/features/chat/screens/my_message_card.dart';
import 'package:whatsapp_cl/features/chat/screens/sender_message_card.dart';
import 'package:whatsapp_cl/models/messsage_model.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiveUserId;
  const ChatList({
    super.key,
    required this.receiveUserId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream:
            ref.watch(chatControllerProvider).getMessages(widget.receiveUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
          return ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final message = snapshot.data![index];
              final time = DateFormat.Hm().format(message.timeStamp);
              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: message.text,
                  date: time,
                  messageEnum: message.type,
                );
              } else {
                return SenderMessageCard(
                  message: message.text,
                  date: time,
                  messageEnum: message.type,
                );
              }
            },
          );
        });
  }
}
