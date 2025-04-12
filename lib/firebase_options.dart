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
    apiKey: 'AIzaSyBh8OBWsgvRpUi1jvxoDZTbEd4w-0Xyuqc',
    appId: '1:787805800356:web:71b02ceea31e1c4773a331',
    messagingSenderId: '787805800356',
    projectId: 'elderwise-find-it',
    authDomain: 'elderwise-find-it.firebaseapp.com',
    storageBucket: 'elderwise-find-it.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLYmkJtj1qdQsl_sY-Q4auykNnZzS6TyQ',
    appId: '1:787805800356:android:0eb0286d1a48768773a331',
    messagingSenderId: '787805800356',
    projectId: 'elderwise-find-it',
    storageBucket: 'elderwise-find-it.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCG314njVp3n1SJFXKj6JS-sXnLWKJ4qy4',
    appId: '1:787805800356:ios:1a19873287080be673a331',
    messagingSenderId: '787805800356',
    projectId: 'elderwise-find-it',
    storageBucket: 'elderwise-find-it.firebasestorage.app',
    iosBundleId: 'com.example.elderwise',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCG314njVp3n1SJFXKj6JS-sXnLWKJ4qy4',
    appId: '1:787805800356:ios:1a19873287080be673a331',
    messagingSenderId: '787805800356',
    projectId: 'elderwise-find-it',
    storageBucket: 'elderwise-find-it.firebasestorage.app',
    iosBundleId: 'com.example.elderwise',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBh8OBWsgvRpUi1jvxoDZTbEd4w-0Xyuqc',
    appId: '1:787805800356:web:3aefaca5c12f470d73a331',
    messagingSenderId: '787805800356',
    projectId: 'elderwise-find-it',
    authDomain: 'elderwise-find-it.firebaseapp.com',
    storageBucket: 'elderwise-find-it.firebasestorage.app',
  );
}
