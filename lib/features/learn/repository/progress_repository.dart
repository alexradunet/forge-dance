import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../model/lesson_progress.dart';

part 'progress_repository.g.dart';

@Riverpod(keepAlive: true)
ProgressRepository progressRepository(Ref ref) => const ProgressRepository();

/// Local-only per-lesson progress storage.
///
/// This repository is the persistence seam for learning progress. The current
/// adapter stores a map in SharedPreferences so the app works fully offline;
/// future cloud/file sync can transfer the same serialized records.
class ProgressRepository {
  const ProgressRepository();

  Future<Map<String, LessonProgress>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(Constants.lessonProgressKey);
    if (encoded == null) return const {};

    final decoded = jsonDecode(encoded) as Map<String, dynamic>;
    return decoded.map(
      (lessonId, value) => MapEntry(
        lessonId,
        LessonProgress.fromJson((value as Map).cast<String, Object?>()),
      ),
    );
  }

  Future<void> upsert(LessonProgress progress) async {
    final all = await getAll();
    await _saveAll({...all, progress.lessonId: progress});
  }

  /// Creates a completion once and preserves the first completion facts across
  /// replays on this device.
  Future<({LessonProgress progress, bool created})> completeOnce(
    LessonProgress completion,
  ) async {
    final all = await getAll();
    final existing = all[completion.lessonId];
    if (existing?.status == LessonStatus.completed) {
      final backfilled = existing!.copyWith(
        completedDate: existing.completedDate ?? _localDate(existing.updatedAt),
        awardedXp: existing.awardedXp ?? completion.awardedXp,
      );
      if (backfilled != existing) {
        await _saveAll({...all, completion.lessonId: backfilled});
      }
      return (progress: backfilled, created: false);
    }

    await _saveAll({...all, completion.lessonId: completion});
    return (progress: completion, created: true);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.lessonProgressKey);
  }

  Future<void> _saveAll(Map<String, LessonProgress> progressByLesson) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      progressByLesson.map((lessonId, progress) => MapEntry(lessonId, progress.toJson())),
    );
    await prefs.setString(Constants.lessonProgressKey, encoded);
  }

  String? _localDate(DateTime? moment) {
    if (moment == null) return null;
    final year = moment.year.toString().padLeft(4, '0');
    final month = moment.month.toString().padLeft(2, '0');
    final day = moment.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
