import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase options for Forge Dance.
///
/// The real values should be generated with FlutterFire CLI:
///
/// ```bash
/// dart pub global activate flutterfire_cli
/// flutterfire configure
/// ```
///
/// Until that is done, the app skips Firebase initialization so local desktop
/// development and CI still work. FlutterFire will overwrite this file with
/// concrete project options once a Firebase project is selected.
class DefaultFirebaseOptions {
  static FirebaseOptions? get currentPlatform {
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    const messagingSenderId = String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
    );
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
    const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
    const storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

    final hasRequiredOptions = apiKey.isNotEmpty &&
        appId.isNotEmpty &&
        messagingSenderId.isNotEmpty &&
        projectId.isNotEmpty;

    if (!hasRequiredOptions) return null;

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: kIsWeb ? authDomain : null,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
    );
  }
}
