import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../features/profile/model/profile.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(
    auth: Firebase.apps.isEmpty ? null : firebase_auth.FirebaseAuth.instance,
    firestore: Firebase.apps.isEmpty ? null : FirebaseFirestore.instance,
  );
}

class ProfileRepository {
  const ProfileRepository({
    required firebase_auth.FirebaseAuth? auth,
    required FirebaseFirestore? firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final firebase_auth.FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  bool get isFirebaseConfigured => _auth != null && _firestore != null;

  Future<Profile?> get() async {
    final firebaseProfile = await _getFromFirestore();
    if (firebaseProfile != null) return firebaseProfile;

    final prefs = await SharedPreferences.getInstance();
    final profileStr = prefs.getString(Constants.profileKey);
    if (profileStr == null) return null;

    return Profile.fromJson(jsonDecode(profileStr));
  }

  Future<void> update(Profile profile) async {
    await _updateLocalProfile(profile);

    final user = _auth?.currentUser;
    if (!isFirebaseConfigured || user == null) return;

    await _firestore!.collection('users').doc(user.uid).set(
      {
        ...profile.toJson(),
        'id': user.uid,
        'email': profile.email ?? user.email,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<Profile?> _getFromFirestore() async {
    final user = _auth?.currentUser;
    if (!isFirebaseConfigured || user == null) return null;

    final snapshot = await _firestore!.collection('users').doc(user.uid).get();
    if (!snapshot.exists) {
      return Profile(
        id: user.uid,
        email: user.email,
        name: user.displayName,
        avatar: user.photoURL,
      );
    }

    final data = snapshot.data();
    if (data == null) return null;

    return Profile.fromJson(_normalizeFirestoreJson(data));
  }

  Future<void> _updateLocalProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.profileKey, jsonEncode(profile.toJson()));
  }

  Map<String, Object?> _normalizeFirestoreJson(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) return MapEntry(key, value.toDate());
      return MapEntry(key, value);
    });
  }
}
