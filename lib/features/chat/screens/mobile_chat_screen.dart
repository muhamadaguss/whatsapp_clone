import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_cl/colors.dart';
import 'package:whatsapp_cl/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_cl/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_cl/models/user_model.dart';
import 'package:whatsapp_cl/features/chat/screens/chat_list.dart';
import 'package:whatsapp_cl/utils/message_enum.dart';
import 'package:whatsapp_cl/utils/utils.dart';

class MobileChatScreen extends ConsumerStatefulWidget {
  final String name;
  final String uid;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  ConsumerState<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends ConsumerState<MobileChatScreen> {
  final TextEditingController _textController = TextEditingController();

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.uid,
          messageEnum,
        );
  }

  void selectImage() async {
    var image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(
        image,
        MessageEnum.image,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel?>(
            stream: ref.read(authControllerProvider).userDataById(widget.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 4.r,
                        backgroundColor: snapshot.data!.isOnline
                            ? Colors.green
                            : Colors.grey,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        snapshot.data!.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              receiveUserId: widget.uid,
            ),
          ),
          Container(
            color: mobileChatBoxColor,
            padding: EdgeInsets.only(
                right: 10.w, left: 10.w, bottom: 20.h, top: 10.h),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      filled: true,
                      fillColor: Colors.grey.withOpacity(
                        .3,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.withOpacity(
                            .4,
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.withOpacity(
                            .4,
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.withOpacity(
                            .4,
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    maxLines:
                        null, // memungkinkan pengguna untuk mengetik banyak baris
                    keyboardType: TextInputType
                        .multiline, // keyboard menampilkan enter dan tombol kembali
                  ),
                ),
                _textController.text != ''
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: IconButton(
                          onPressed: () {
                            ref.read(chatControllerProvider).sendMessage(
                                  context,
                                  _textController.text,
                                  widget.uid,
                                );
                            _textController.clear();
                          },
                          icon: const Icon(
                            Icons.send,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: selectImage,
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                                size: 20.sp,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.attach_file,
                                color: Colors.grey,
                                size: 20.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
