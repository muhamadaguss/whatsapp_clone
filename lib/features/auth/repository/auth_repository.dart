// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_cl/models/user_model.dart';
import 'package:whatsapp_cl/utils/common_firebase_storage_repository.dart';
import 'package:whatsapp_cl/utils/utils.dart';
import 'package:path/path.dart' as p;

final authRepositoryProvider = Provider(
  (ref) {
    return AuthRepository(
      auth: FirebaseAuth.instance,
      firebaseFirestore: FirebaseFirestore.instance,
    );
  },
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firebaseFirestore;
  AuthRepository({
    required this.auth,
    required this.firebaseFirestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhoneNumber(BuildContext context, String number) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          // throw Exception(error.message ?? 'Something went wrong');
          showSnackbar(
              context: context,
              content: error.message ?? 'Something went wrong');
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.pushNamed(
            context,
            '/otp',
            arguments: {
              'verificationId': verificationId,
              'number': number,
            },
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackbar(
        context: context,
        content: e.message ?? 'Something went wrong',
      );
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String otp,
    required String number,
  }) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(phoneAuthCredential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/user-info',
        (route) => false,
        arguments: {
          'number': number,
        },
      );
    } on FirebaseAuthException catch (e) {
      showSnackbar(
        context: context,
        content: e.message ?? 'Something went wrong',
      );
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? image,
    required ProviderRef ref,
    required BuildContext context,
    required String number,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-profile.png';

      if (image != null) {
        photoUrl =
            await ref.read(commonFirebaseStorageRepositoryProvider).uploadImage(
                  path: 'profilePic/$uid',
                  fileName: '$name${p.extension(image.path)}',
                  image: image,
                );
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: number,
        groupId: [],
      );

      await firebaseFirestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    } catch (e) {
      showSnackbar(
        context: context,
        content: e.toString(),
      );
    }
  }

  Stream<UserModel?> userData(String userId) {
    return firebaseFirestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setStatus(bool isOnline, BuildContext context) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser?.uid)
          .update(
        {'isOnline': isOnline},
      );
    } catch (e) {
      showSnackbar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
