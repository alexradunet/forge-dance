import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

@Riverpod(keepAlive: true)
bool isFirebaseConfigured(Ref ref) {
  return Firebase.apps.isNotEmpty;
}

@Riverpod(keepAlive: true)
firebase_auth.FirebaseAuth? firebaseAuth(Ref ref) {
  if (!ref.watch(isFirebaseConfiguredProvider)) return null;
  return firebase_auth.FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
FirebaseFirestore? firebaseFirestore(Ref ref) {
  if (!ref.watch(isFirebaseConfiguredProvider)) return null;
  return FirebaseFirestore.instance;
}
