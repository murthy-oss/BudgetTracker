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
    apiKey: 'AIzaSyCyLF6VVn0KYn87kr8YI6GqcsCdO0D2obE',
    appId: '1:1080008252023:web:037ab414a792f1b1e3c472',
    messagingSenderId: '1080008252023',
    projectId: 'budgettracker-7282c',
    authDomain: 'budgettracker-7282c.firebaseapp.com',
    storageBucket: 'budgettracker-7282c.appspot.com',
    measurementId: 'G-EGNKZ8DW4S',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBeeFcYrQgizuCJ3lk4EXqKTbKesKoSmV0',
    appId: '1:1080008252023:ios:79c463c66791fc25e3c472',
    messagingSenderId: '1080008252023',
    projectId: 'budgettracker-7282c',
    storageBucket: 'budgettracker-7282c.appspot.com',
    iosBundleId: 'com.example.expensemate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBeeFcYrQgizuCJ3lk4EXqKTbKesKoSmV0',
    appId: '1:1080008252023:ios:79c463c66791fc25e3c472',
    messagingSenderId: '1080008252023',
    projectId: 'budgettracker-7282c',
    storageBucket: 'budgettracker-7282c.appspot.com',
    iosBundleId: 'com.example.expensemate',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCyLF6VVn0KYn87kr8YI6GqcsCdO0D2obE',
    appId: '1:1080008252023:web:fb8af5189355cf34e3c472',
    messagingSenderId: '1080008252023',
    projectId: 'budgettracker-7282c',
    authDomain: 'budgettracker-7282c.firebaseapp.com',
    storageBucket: 'budgettracker-7282c.appspot.com',
    measurementId: 'G-MHEVYBD28T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAT6eqi1_LZyF1ViTnkmjuVhzEXPTI0LGY',
    appId: '1:1080008252023:android:896400fc36f11e56e3c472',
    messagingSenderId: '1080008252023',
    projectId: 'budgettracker-7282c',
    storageBucket: 'budgettracker-7282c.appspot.com',
  );

}