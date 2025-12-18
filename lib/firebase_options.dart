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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  //  Web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDOqBpCG6dcyADfM90PnBJMfTiAzPXoV1Q',
    appId: '1:951110180167:web:26416f66ce2a7d3f084062',
    messagingSenderId: '951110180167',
    projectId: 'avioflai-app-934cc',
    authDomain: 'avioflai-app-934cc.firebaseapp.com',
    storageBucket: 'avioflai-app-934cc.firebasestorage.app',
    measurementId: 'G-LFZFTH2PY1',
  );

  //  Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2dlWvWP-wLhZHzTjsyIVSoDdvwgNawNc',
    appId: '1:951110180167:android:747cb971947acb26084062',
    messagingSenderId: '951110180167',
    projectId: 'avioflai-app-934cc',
    storageBucket: 'avioflai-app-934cc.appspot.com',
  );

  //  iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCvCyWPkuK4Z6h5yg0YQAtz-6Hgoj-qTvI',
    appId: '1:951110180167:ios:a846f5aa45e2abdf084062',
    messagingSenderId: '951110180167',
    projectId: 'avioflai-app-934cc',
    storageBucket: 'avioflai-app-934cc.appspot.com',
    iosBundleId: 'com.avioflai.aviation',
    iosClientId:
        '951110180167-a4d8j4fjjvpibaa8or8kthl310p81q7i.apps.googleusercontent.com',
  );
}
