// File generated for Firebase configuration.
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
        return ios;
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
    apiKey: 'AIzaSyBhnTLseeDtW9wlK8DHdyzbdQMJV4vbrGo',
    appId: '1:931003042441:web:3972ce84224f364298d458',
    messagingSenderId: '931003042441',
    projectId: 'protect312-ae4c7',
    authDomain: 'protect312-ae4c7.firebaseapp.com',
    storageBucket: 'protect312-ae4c7.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhnTLseeDtW9wlK8DHdyzbdQMJV4vbrGo',
    appId: '1:931003042441:android:3972ce84224f364298d458',
    messagingSenderId: '931003042441',
    projectId: 'protect312-ae4c7',
    storageBucket: 'protect312-ae4c7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhnTLseeDtW9wlK8DHdyzbdQMJV4vbrGo',
    appId: '1:931003042441:ios:3972ce84224f364298d458',
    messagingSenderId: '931003042441',
    projectId: 'protect312-ae4c7',
    storageBucket: 'protect312-ae4c7.firebasestorage.app',
    iosBundleId: 'com.example.project312.nexusHabitat',
  );
}
