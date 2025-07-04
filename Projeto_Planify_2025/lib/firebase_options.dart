

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAm9gM9hkEdpCNaA5n3SU41kOaJyjLaHvg',
    appId: '1:941867490847:web:ef8da0a1b5cf3ac5f67f2a',
    messagingSenderId: '941867490847',
    projectId: 'planify-f4b33',
    authDomain: 'planify-f4b33.firebaseapp.com',
    storageBucket: 'planify-f4b33.firebasestorage.app',
    measurementId: 'G-TLFXQPRMEM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyATnEyYNkgZLNX2HwiiVnAn5_aj0IO9_C0',
    appId: '1:941867490847:android:6ac7c5aa86c18efbf67f2a',
    messagingSenderId: '941867490847',
    projectId: 'planify-f4b33',
    storageBucket: 'planify-f4b33.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjLp6ub-yYGW4Y-rp8GYd7w4dFu0fVCXA',
    appId: '1:941867490847:ios:f4d59249c59fa8fbf67f2a',
    messagingSenderId: '941867490847',
    projectId: 'planify-f4b33',
    storageBucket: 'planify-f4b33.firebasestorage.app',
    iosBundleId: 'com.example.planify',
  );
}
