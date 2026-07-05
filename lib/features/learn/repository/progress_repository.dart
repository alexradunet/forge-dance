import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../firebase/repository/firebase_providers.dart';
import '../model/lesson_progress.dart';

part 'progress_repository.g.dart';

@Riverpod(keepAlive: true)
ProgressRepository progressRepository(Ref ref) {
  return ProgressRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// Per-user lesson progress at `users/{uid}/progress/{lessonId}`.
///
/// Reads and writes are typed via `withConverter`, and everything degrades
/// gracefully when Firebase is unconfigured or nobody is signed in: reads
/// return empty, writes no-op (progress then lives only in memory for the
/// session — fine for local dev mode).
class ProgressRepository {
  const ProgressRepository({
    required firebase_auth.FirebaseAuth? auth,
    required FirebaseFirestore? firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final firebase_auth.FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  bool get isFirebaseConfigured => _auth != null && _firestore != null;

  CollectionReference<LessonProgress>? _progressRef() {
    final user = _auth?.currentUser;
    final firestore = _firestore;
    if (firestore == null || user == null) return null;

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .withConverter<LessonProgress>(
          fromFirestore: (snapshot, _) =>
              LessonProgress.fromJson(_normalizeFirestoreJson(snapshot.data()!)),
          toFirestore: (progress, _) => _firestorePayload(progress),
        );
  }

  /// All progress documents for the signed-in user, keyed by lesson id.
  Future<Map<String, LessonProgress>> getAll() async {
    final ref = _progressRef();
    if (ref == null) return const {};

    final snapshot = await ref.get();
    return {
      for (final doc in snapshot.docs) doc.data().lessonId: doc.data(),
    };
  }

  /// Creates or updates the progress document for `progress.lessonId`.
  Future<void> upsert(LessonProgress progress) async {
    final ref = _progressRef();
    if (ref == null) return;

    await ref.doc(progress.lessonId).set(progress, SetOptions(merge: true));
  }

  Map<String, Object?> _firestorePayload(LessonProgress progress) {
    final payload = progress.toJson()
      ..['updatedAt'] = FieldValue.serverTimestamp();
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
