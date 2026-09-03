import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../model/workout_session.dart';

part 'session_repository.g.dart';

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) => const SessionRepository();

/// Local-only completed workout session storage.
///
/// The deterministic [WorkoutSession.docKey] keeps daily workout completion
/// idempotent on this device. Future sync can export/import this same record
/// map as a transferable file.
class SessionRepository {
  const SessionRepository();

  Future<List<WorkoutSession>> getAll() async {
    final sessions = await _getByKey();
    return sessions.values.toList(growable: false);
  }

  Future<void> complete(WorkoutSession session) async {
    final all = await _getByKey();
    await _saveByKey({...all, session.docKey: session});
  }

  /// Creates a daily completion once and returns the preserved record.
  Future<({WorkoutSession session, bool created})> completeOnce(
    WorkoutSession completion,
  ) async {
    final all = await _getByKey();
    final existing = all[completion.docKey];
    if (existing != null) {
      final backfilled = existing.copyWith(
        awardedXp: existing.awardedXp ?? completion.awardedXp,
      );
      if (backfilled != existing) {
        await _saveByKey({...all, completion.docKey: backfilled});
      }
      return (session: backfilled, created: false);
    }

    await _saveByKey({...all, completion.docKey: completion});
    return (session: completion, created: true);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.workoutSessionsKey);
  }

  Future<Map<String, WorkoutSession>> _getByKey() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(Constants.workoutSessionsKey);
    if (encoded == null) return const {};

    final decoded = jsonDecode(encoded) as Map<String, dynamic>;
    return decoded.map(
      (docKey, value) => MapEntry(
        docKey,
        WorkoutSession.fromJson((value as Map).cast<String, Object?>()),
      ),
    );
  }

  Future<void> _saveByKey(Map<String, WorkoutSession> sessionsByKey) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      sessionsByKey.map((docKey, session) => MapEntry(docKey, session.toJson())),
    );
    await prefs.setString(Constants.workoutSessionsKey, encoded);
  }
}
