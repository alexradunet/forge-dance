import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../../firebase_options.dart';

/// True when the app was started with
/// `--dart-define=USE_FIREBASE_EMULATOR=true`.
///
/// Local dev loop:
///   firebase emulators:start
///   flutter run --dart-define=USE_FIREBASE_EMULATOR=true
/// Ports live in firebase.json (auth 9099, firestore 8080).
const bool useFirebaseEmulator = bool.fromEnvironment('USE_FIREBASE_EMULATOR');

/// Hostname used by clients to reach the local Firebase Emulator Suite.
///
/// Android emulators use `10.0.2.2` to reach the development host. Other local
/// targets use the default `localhost`.
const String firebaseEmulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: 'localhost',
);

/// Initializes Firebase for the current platform.
///
/// Platforms without generated options (Linux) skip initialization — the
/// nullable providers in firebase_providers.dart then hand out null and the
/// app runs in local dev mode (see lib/routing/app_redirect.dart).
Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError catch (error) {
    debugPrint('Firebase is not supported on this platform: $error');
    return;
  }

  if (useFirebaseEmulator) {
    await firebase_auth.FirebaseAuth.instance.useAuthEmulator(
      firebaseEmulatorHost,
      9099,
    );
    FirebaseFirestore.instance.useFirestoreEmulator(firebaseEmulatorHost, 8080);
    debugPrint(
      'Firebase: using local emulator suite '
      '($firebaseEmulatorHost; auth :9099, firestore :8080)',
    );
  }
}
