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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDv8LmYRHWanoJDyqE_g7DJL_r5YQs5Q4E',
    appId: '1:662994612518:android:162bc6096f76273c2e91e7',
    messagingSenderId: '662994612518',
    projectId: 'fir-bf0a4',
    databaseURL: 'https://fir-bf0a4-default-rtdb.firebaseio.com',
    storageBucket: 'fir-bf0a4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9XgX9AnSHZDS4-ilqy8zp-OuV72f9aPA',
    appId: '1:662994612518:ios:bac176e0b6039a092e91e7',
    messagingSenderId: '662994612518',
    projectId: 'fir-bf0a4',
    databaseURL: 'https://fir-bf0a4-default-rtdb.firebaseio.com',
    storageBucket: 'fir-bf0a4.appspot.com',
    iosBundleId: 'com.example.flutterApplication',
  );
}
