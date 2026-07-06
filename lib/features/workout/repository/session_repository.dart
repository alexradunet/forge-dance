import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firebase/repository/firebase_providers.dart';
import '../model/workout_session.dart';

part 'session_repository.g.dart';

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// Completed workout sessions at `users/{uid}/sessions/{date}_{workoutId}`.
/// The deterministic doc id makes completion idempotent: repeating the same
/// workout on the same day overwrites instead of double-counting XP.
/// Degrades gracefully when Firebase is unconfigured or signed out.
class SessionRepository {
  const SessionRepository({
    required firebase_auth.FirebaseAuth? auth,
    required FirebaseFirestore? firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final firebase_auth.FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  bool get isFirebaseConfigured => _auth != null && _firestore != null;

  CollectionReference<WorkoutSession>? _sessionsRef() {
    final user = _auth?.currentUser;
    final firestore = _firestore;
    if (firestore == null || user == null) return null;

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .withConverter<WorkoutSession>(
          fromFirestore: (snapshot, _) =>
              WorkoutSession.fromJson(_normalizeFirestoreJson(snapshot.data()!)),
          toFirestore: (session, _) => _firestorePayload(session),
        );
  }

  Future<List<WorkoutSession>> getAll() async {
    final ref = _sessionsRef();
    if (ref == null) return const [];

    final snapshot = await ref.get();
    return [for (final doc in snapshot.docs) doc.data()];
  }

  Future<void> complete(WorkoutSession session) async {
    final ref = _sessionsRef();
    if (ref == null) return;

    await ref.doc(session.docKey).set(session, SetOptions(merge: true));
  }

  Map<String, Object?> _firestorePayload(WorkoutSession session) {
    final payload = session.toJson()
      ..remove('completedAt')
      ..['completedAt'] = FieldValue.serverTimestamp();
    return payload;
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
}
