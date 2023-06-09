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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyATqwrEFGvi-687dDuQ23AtnUTklRlVnl0',
    appId: '1:739569595981:web:7a9d7a3247533321200e04',
    messagingSenderId: '739569595981',
    projectId: 'fireapp-56e97',
    authDomain: 'fireapp-56e97.firebaseapp.com',
    storageBucket: 'fireapp-56e97.appspot.com',
    measurementId: 'G-4T8JLKRXH7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBHGRKR5oGS8JAinG72lghUC0igAW_vi5o',
    appId: '1:739569595981:android:463603f63bcb27fc200e04',
    messagingSenderId: '739569595981',
    projectId: 'fireapp-56e97',
    storageBucket: 'fireapp-56e97.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcjezRWLFgOwmOUlNWwYkvU0NJoUmXzho',
    appId: '1:739569595981:ios:d53436d7b7e128dc200e04',
    messagingSenderId: '739569595981',
    projectId: 'fireapp-56e97',
    storageBucket: 'fireapp-56e97.appspot.com',
    iosClientId: '739569595981-9cb30fq134gc21rrgrbftrjt670hjm7h.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebase',
  );
}
