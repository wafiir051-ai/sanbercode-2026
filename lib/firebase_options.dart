// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyB2LePUL-1CI3S-JDXqd7so-loePmmFQoc',
    appId: '1:337470052416:android:cdd9b4eacab7d50fd667a5',
    messagingSenderId: '337470052416',
    projectId: 'kicksstore-smk-waffir',
    storageBucket: 'kicksstore-smk-waffir.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwMVruM5UVwcR5HXPjxNDcxjOKWNnAvy8',
    appId: '1:337470052416:ios:a87d9e6a9ac4eec9d667a5',
    messagingSenderId: '337470052416',
    projectId: 'kicksstore-smk-waffir',
    storageBucket: 'kicksstore-smk-waffir.firebasestorage.app',
    iosBundleId: 'com.example.eCommerceSmk',
  );
}
