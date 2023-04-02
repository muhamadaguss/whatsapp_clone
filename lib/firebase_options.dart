// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAHqqxeyt47hmm6e3hewwhf3r52CAaQMd4',
    appId: '1:906580987678:web:c65a4e143603761319830f',
    messagingSenderId: '906580987678',
    projectId: 'whatsappclone-8501b',
    authDomain: 'whatsappclone-8501b.firebaseapp.com',
    storageBucket: 'whatsappclone-8501b.appspot.com',
    measurementId: 'G-J3C968XFHJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzkn2APsKfhx5Q5P2UosajjofXrdHa-HY',
    appId: '1:906580987678:android:c440a77e890a145919830f',
    messagingSenderId: '906580987678',
    projectId: 'whatsappclone-8501b',
    storageBucket: 'whatsappclone-8501b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKugRdcw4G2Fu1w2VZRwUkZx2x81vcrGY',
    appId: '1:906580987678:ios:5de64abd7f32e04719830f',
    messagingSenderId: '906580987678',
    projectId: 'whatsappclone-8501b',
    storageBucket: 'whatsappclone-8501b.appspot.com',
    iosClientId: '906580987678-r63t7ejbu30ecujjmi7i34njjgs63g8n.apps.googleusercontent.com',
    iosBundleId: 'com.whatsapp.clone.whatsappCl',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKugRdcw4G2Fu1w2VZRwUkZx2x81vcrGY',
    appId: '1:906580987678:ios:5de64abd7f32e04719830f',
    messagingSenderId: '906580987678',
    projectId: 'whatsappclone-8501b',
    storageBucket: 'whatsappclone-8501b.appspot.com',
    iosClientId: '906580987678-r63t7ejbu30ecujjmi7i34njjgs63g8n.apps.googleusercontent.com',
    iosBundleId: 'com.whatsapp.clone.whatsappCl',
  );
}
