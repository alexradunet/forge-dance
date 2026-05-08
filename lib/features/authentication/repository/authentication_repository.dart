import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/constants/constants.dart';
import '../model/auth_session.dart';

part 'authentication_repository.g.dart';

@riverpod
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepository(
    auth: Firebase.apps.isEmpty ? null : firebase_auth.FirebaseAuth.instance,
    firestore: Firebase.apps.isEmpty ? null : FirebaseFirestore.instance,
  );
}

class AuthenticationRepository {
  const AuthenticationRepository({
    required firebase_auth.FirebaseAuth? auth,
    required FirebaseFirestore? firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final firebase_auth.FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  bool get isFirebaseConfigured => _auth != null && _firestore != null;

  Future<AuthSession> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _assertFirebaseConfigured();

    try {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthenticationException('Registration failed.');
      }

      await _ensureUserDocument(user);
      await setIsLogin(true);
      await setIsExistAccount(true);
      return _sessionFromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw AuthenticationException(_messageForFirebaseAuthError(error));
    }
  }

  Future<AuthSession> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _assertFirebaseConfigured();

    try {
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthenticationException('Sign in failed.');
      }

      await _ensureUserDocument(user);
      await setIsLogin(true);
      await setIsExistAccount(true);
      return _sessionFromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw AuthenticationException(_messageForFirebaseAuthError(error));
    }
  }

  Future<AuthSession?> currentSession() async {
    final user = _auth?.currentUser;
    if (user == null) return null;
    return _sessionFromFirebaseUser(user);
  }

  Future<void> signOut() async {
    await _auth?.signOut();
    await setIsLogin(false);
  }

  Future<bool> isLogin() async {
    if (_auth?.currentUser != null) return true;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.isLoginKey) ?? false;
  }

  Future<void> setIsLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isLoginKey, value);
  }

  Future<bool> isExistAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.isExistAccountKey) ?? false;
  }

  Future<void> setIsExistAccount(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isExistAccountKey, value);
  }

  void _assertFirebaseConfigured() {
    if (!isFirebaseConfigured) {
      throw const AuthenticationException(
        'Firebase is not configured. Run `flutterfire configure` and enable Email/Password sign-in.',
      );
    }
  }

  Future<void> _ensureUserDocument(firebase_auth.User user) async {
    final doc = _firestore!.collection('users').doc(user.uid);
    final snapshot = await doc.get();

    final data = <String, dynamic>{
      'id': user.uid,
      'email': user.email,
      'name': user.displayName,
      'avatar': user.photoURL,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (snapshot.exists) {
      await doc.set(data, SetOptions(merge: true));
    } else {
      await doc.set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  AuthSession _sessionFromFirebaseUser(firebase_auth.User user) {
    return AuthSession(
      user: AuthUser(
        id: user.uid,
        email: user.email,
        metadata: {
          'full_name': user.displayName,
          'avatar_url': user.photoURL,
        },
      ),
    );
  }

  String _messageForFirebaseAuthError(
      firebase_auth.FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled for this Firebase project.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'weak-password':
        return 'Use a stronger password.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return error.message ?? 'Authentication failed.';
    }
  }
}

class AuthenticationException implements Exception {
  const AuthenticationException(this.message);

  final String message;

  @override
  String toString() => message;
}
