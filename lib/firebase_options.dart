

// File generated manually based on provided Google service files.
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
          'DefaultFirebaseOptions have not been configured for Windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
     apiKey: "AIzaSyAd4TXx6ri4c4MdnbY0DolLy78xw6zsuzk",
  authDomain: "iot-smart-home-e1a26.firebaseapp.com",
  projectId: "iot-smart-home-e1a26",
  storageBucket: "iot-smart-home-e1a26.firebasestorage.app",
  messagingSenderId: "56518374985",
  appId: "1:56518374985:web:84f8b7c0d53e8f497df198",
  measurementId: "G-CDSZ1MVFH9"
  );

  static const FirebaseOptions android = FirebaseOptions(
     apiKey: "AIzaSyAd4TXx6ri4c4MdnbY0DolLy78xw6zsuzk",
  authDomain: "iot-smart-home-e1a26.firebaseapp.com",
  projectId: "iot-smart-home-e1a26",
  storageBucket: "iot-smart-home-e1a26.firebasestorage.app",
  messagingSenderId: "56518374985",
  appId: "1:56518374985:web:84f8b7c0d53e8f497df198",
  measurementId: "G-CDSZ1MVFH9"
  );

  static const FirebaseOptions ios = FirebaseOptions(
     apiKey: "AIzaSyAd4TXx6ri4c4MdnbY0DolLy78xw6zsuzk",
  authDomain: "iot-smart-home-e1a26.firebaseapp.com",
  projectId: "iot-smart-home-e1a26",
  storageBucket: "iot-smart-home-e1a26.firebasestorage.app",
  messagingSenderId: "56518374985",
  appId: "1:56518374985:web:84f8b7c0d53e8f497df198",
  measurementId: "G-CDSZ1MVFH9"
  );

  static const FirebaseOptions macos = FirebaseOptions(
     apiKey: "AIzaSyAd4TXx6ri4c4MdnbY0DolLy78xw6zsuzk",
  authDomain: "iot-smart-home-e1a26.firebaseapp.com",
  projectId: "iot-smart-home-e1a26",
  storageBucket: "iot-smart-home-e1a26.firebasestorage.app",
  messagingSenderId: "56518374985",
  appId: "1:56518374985:web:84f8b7c0d53e8f497df198",
  measurementId: "G-CDSZ1MVFH9"
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyAd4TXx6ri4c4MdnbY0DolLy78xw6zsuzk",
  authDomain: "iot-smart-home-e1a26.firebaseapp.com",
  projectId: "iot-smart-home-e1a26",
  storageBucket: "iot-smart-home-e1a26.firebasestorage.app",
  messagingSenderId: "56518374985",
  appId: "1:56518374985:web:84f8b7c0d53e8f497df198",
  measurementId: "G-CDSZ1MVFH9"
  );

}