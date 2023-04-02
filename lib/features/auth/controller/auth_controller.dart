import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_cl/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_cl/models/user_model.dart';

final authControllerProvider = Provider(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(
      authRepository: authRepository,
      ref: ref,
    );
  },
);

final userDataAuthProvider = FutureProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider);
    return authController.getCurrentUserData();
  },
);

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  void signInWithPhone(BuildContext context, String number) {
    authRepository.signInWithPhoneNumber(context, number);
  }

  void verifyOTP(
      BuildContext context, String verificationId, String otp, String number) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      otp: otp,
      number: number,
    );
  }

  void saveUserDataToFirebase(
    BuildContext context,
    String name,
    File? image,
    String number,
  ) {
    authRepository.saveUserDataToFirebase(
      name: name,
      image: image,
      ref: ref,
      context: context,
      number: number,
    );
  }

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel?> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setStatus(BuildContext context, bool isOnline) {
    authRepository.setStatus(
      isOnline,
      context,
    );
  }
}
