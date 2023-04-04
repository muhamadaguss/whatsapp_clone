import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_cl/colors.dart';
import 'package:whatsapp_cl/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_cl/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_cl/models/user_model.dart';
import 'package:whatsapp_cl/features/chat/screens/chat_list.dart';
import 'package:whatsapp_cl/utils/message_enum.dart';
import 'package:whatsapp_cl/utils/utils.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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
  bool emojiShowing = false;
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardVisible = false;

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isKeyboardVisible) {
      setState(() {
        this.isKeyboardVisible = isKeyboardVisible;
      });

      if (isKeyboardVisible && emojiShowing) {
        setState(() {
          emojiShowing = false;
        });
      }
    });
    super.initState();
  }

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

  void pickCamera() async {
    var image = await pickImageFromCamera(context);
    if (image != null) {
      sendFileMessage(
        image,
        MessageEnum.image,
      );
    }
  }

  void onClickedEmoji() async {
    if (emojiShowing) {
      _focusNode.requestFocus();
    } else if (isKeyboardVisible) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(
        const Duration(milliseconds: 100),
      );
    }
    toggleEmojiKeyboard();
  }

  Future toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }

    setState(() {
      emojiShowing = !emojiShowing;
    });
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(
          18.w,
        ),
        child: Padding(
          padding: EdgeInsets.all(24.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      pickCamera();
                      Navigator.pop(context);
                    },
                    child: iconCorrection(
                      Colors.pink,
                      Icons.camera_alt_rounded,
                      'Camera',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectImage();
                      Navigator.pop(context);
                    },
                    child: iconCorrection(
                      Colors.purple,
                      Icons.photo,
                      'Gallery',
                    ),
                  ),
                  iconCorrection(
                    Colors.amber,
                    Icons.headphones,
                    'Audio',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCorrection(
    Color color,
    IconData iconData,
    String text,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: color,
          child: Icon(
            iconData,
            color: Colors.white,
            size: 25.sp,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
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
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => bottomSheet(),
                      );
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.grey,
                      size: 20.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 100.h,
                    ),
                    child: Container(
                      // height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.3),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.grey.withOpacity(.7),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              focusNode: _focusNode,
                              onChanged: (value) {
                                setState(() {});
                              },
                              onTap: () {
                                setState(() {
                                  emojiShowing = false;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type a message',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                              ),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                          GestureDetector(
                            onTap: onClickedEmoji,
                            child: Icon(
                              Icons.emoji_emotions_outlined,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          )
                        ],
                      ),
                    ),
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
                    : Row(
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
              ],
            ),
          ),
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
                height: 200.h,
                child: EmojiPicker(
                  textEditingController: _textController,
                  config: Config(
                    columns: 10,
                    // Issue: https://github.com/flutter/flutter/issues/28894
                    // emojiSizeMax: 32.sp *
                    //     (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    //         ? 1.30
                    //         : 1.0),
                    emojiSizeMax: 20.sp,
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: mobileChatBoxColor,
                    indicatorColor: Colors.grey.withOpacity(.6),
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.grey.withOpacity(.6),
                    backspaceColor: Colors.grey.withOpacity(.6),
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: Text(
                      'No Recents',
                      style: TextStyle(fontSize: 16.sp, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: const SizedBox.shrink(),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                    checkPlatformCompatibility: true,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
