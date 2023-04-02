import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  (ref) {
    return CommonFirebaseStorageRepository(
      firebaseStorage: FirebaseStorage.instance,
    );
  },
);

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStorageRepository({
    required this.firebaseStorage,
  });

  Future<String> uploadImage({
    required String path,
    required String fileName,
    required File image,
  }) async {
    final ref = firebaseStorage.ref().child(path).child(fileName);
    await ref.putFile(image);
    final url = await ref.getDownloadURL();
    return url;
  }
}
