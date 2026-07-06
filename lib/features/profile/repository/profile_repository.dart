import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../extensions/string_extension.dart';
import '../../../features/firebase/repository/firebase_providers.dart';
import '../../../features/profile/model/profile.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
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

  /// Typed reference to the signed-in user's profile document.
  ///
  /// All Firestore reads/writes go through this converter so field names and
  /// types are checked in exactly one place. Null when Firebase is
  /// unconfigured or nobody is signed in.
  DocumentReference<Profile>? _profileRef() {
    final user = _auth?.currentUser;
    final firestore = _firestore;
    if (firestore == null || user == null) return null;

    return firestore.collection('users').doc(user.uid).withConverter<Profile>(
          fromFirestore: (snapshot, _) =>
              Profile.fromJson(_normalizeFirestoreJson(snapshot.data()!)),
          toFirestore: (profile, _) =>
              _firestorePayload(profile: profile, user: user),
        );
  }

  Future<Profile?> get() async {
    final localProfile = await _getLocalProfile();
    final firebaseProfile = await _getFromFirestore();
    if (firebaseProfile != null) {
      return _mergeLocalOnlyFields(
        firebaseProfile: firebaseProfile,
        localProfile: localProfile,
      );
    }

    return localProfile;
  }

  Future<Profile?> _getLocalProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileStr = prefs.getString(Constants.profileKey);
    if (profileStr == null) return null;

    return Profile.fromJson(jsonDecode(profileStr));
  }

  Future<void> update(Profile profile) async {
    await _updateLocalProfile(profile);

    final ref = _profileRef();
    if (ref == null) return;

    await ref.set(profile, SetOptions(merge: true));
  }

  Future<Profile?> _getFromFirestore() async {
    final user = _auth?.currentUser;
    final ref = _profileRef();
    if (ref == null || user == null) return null;

    final snapshot = await ref.get();
    if (!snapshot.exists) {
      return Profile(
        id: user.uid,
        email: user.email,
        name: user.displayName,
        avatar: user.photoURL,
      );
    }

    return snapshot.data();
  }

  Future<void> _updateLocalProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.profileKey, jsonEncode(profile.toJson()));
  }

  Map<String, Object?> _normalizeFirestoreJson(Map<String, dynamic> data) {
    return data.map((key, value) {
      // json_serializable expects ISO-8601 strings for DateTime fields.
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }

  Profile _mergeLocalOnlyFields({
    required Profile firebaseProfile,
    required Profile? localProfile,
  }) {
    final localAvatar = localProfile?.avatar;
    if (localAvatar == null ||
        localAvatar.isUrl ||
        !File(localAvatar).existsSync() ||
        !_isSameProfile(
            firebaseProfile: firebaseProfile, localProfile: localProfile)) {
      return firebaseProfile;
    }

    return firebaseProfile.copyWith(avatar: localAvatar);
  }

  bool _isSameProfile({
    required Profile firebaseProfile,
    required Profile? localProfile,
  }) {
    if (localProfile == null) return false;

    final firebaseId = firebaseProfile.id;
    final localId = localProfile.id;
    if (firebaseId != null && localId != null && firebaseId == localId) {
      return true;
    }

    final firebaseEmail = firebaseProfile.email;
    final localEmail = localProfile.email;
    return firebaseEmail != null &&
        localEmail != null &&
        firebaseEmail == localEmail;
  }

  Map<String, Object?> _firestorePayload({
    required Profile profile,
    required firebase_auth.User user,
  }) {
    final payload = <String, Object?>{
      'id': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final email = profile.email ?? user.email;
    if (email != null) payload['email'] = email;
    if (profile.name != null) payload['name'] = profile.name;
    if (profile.job != null) payload['job'] = profile.job;
    if (profile.diamond != null) payload['diamond'] = profile.diamond;
    if (profile.xp != null) payload['xp'] = profile.xp;
    if (profile.streakCount != null) {
      payload['streakCount'] = profile.streakCount;
    }
    if (profile.lastActivityDate != null) {
      payload['lastActivityDate'] = profile.lastActivityDate;
    }

    final avatar = profile.avatar;
    if (avatar != null && avatar.isUrl) {
      payload['avatar'] = avatar;
    }

    return payload;
  }
}
