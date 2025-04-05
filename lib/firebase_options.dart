// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAFlpqcvU61bVTnY_0go9ZgqSwQ3kXX3Z8',
    appId: '1:133393946896:web:20b5449d128c1c90816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    authDomain: 'alialqattandev.firebaseapp.com',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
    measurementId: 'G-J5Q0EX54WB',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAFlpqcvU61bVTnY_0go9ZgqSwQ3kXX3Z8',
    appId: '1:133393946896:web:20b5449d128c1c90816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    authDomain: 'alialqattandev.firebaseapp.com',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
    measurementId: 'G-J5Q0EX54WB',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAAxmMgR-id2KAzpJ-9XgbfGSmKRajfrb8',
    appId: '1:133393946896:ios:7f8180f255b0b379816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
    iosBundleId: 'com.example.portfolioCore',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAxmMgR-id2KAzpJ-9XgbfGSmKRajfrb8',
    appId: '1:133393946896:ios:7f8180f255b0b379816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
    iosBundleId: 'com.example.portfolioCore',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDXNjK5l-ExhjpI3leZM4Jyh5ZvFQYUazY',
    appId: '1:133393946896:android:d481cd330c8f6025816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
  );

}