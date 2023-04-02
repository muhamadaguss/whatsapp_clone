import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_cl/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_cl/utils/utils.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> arguments;
  const UserInformationScreen({
    super.key,
    required this.arguments,
  });

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    _image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = _nameController.text.trim();

    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            _image,
            widget.arguments['number'],
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  _image == null
                      ? CircleAvatar(
                          backgroundImage: const AssetImage(
                            'assets/empty.png',
                          ),
                          radius: 64.r,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(_image!),
                          radius: 64.r,
                        ),
                  Positioned(
                    bottom: -10.h,
                    left: 90.w,
                    child: IconButton(
                      enableFeedback: false,
                      splashColor: Colors.transparent,
                      splashRadius: 1,
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 1.sw * .85,
                    padding: EdgeInsets.all(20.w),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserData,
                    icon: const Icon(
                      Icons.done,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
