import 'dart:convert';
import 'dart:ui' show Rect;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../learn/model/lesson_progress.dart';
import '../../media/repository/media_repository.dart';
import '../../method/model/forge_method.dart';
import '../../practice/model/practice.dart';
import '../../profile/model/profile.dart';
import '../../programmes/repository/programme_repository.dart';
import '../../workout/model/workout_session.dart';

part 'portable_backup_repository.g.dart';

@Riverpod(keepAlive: true)
PortableBackupRepository portableBackupRepository(Ref ref) =>
    PortableBackupRepository(ref.watch(mediaRepositoryProvider));

/// Portable semantic sections, independent of the local preference key names.
const _sectionKeys = {
  'profile': Constants.profileKey,
  'lessons': Constants.lessonProgressKey,
  'workouts': Constants.workoutSessionsKey,
  'method': Constants.methodProgressKey,
  'practice': Constants.practiceRecordsKey,
  'practicePreferences': Constants.practicePreferencesKey,
  'programmes': Constants.programmeEnrolmentsKey,
};

class PortableBackupRepository {
  PortableBackupRepository(this._media);
  final MediaRepository _media;
  bool _restoring = false;
  static const maxBackupBytes = 150 * 1024 * 1024;

  Future<String> exportJson() async {
    if (_restoring) throw StateError('A restore is already in progress.');
    final prefs = await SharedPreferences.getInstance();
    final sections = <String, Object?>{
      for (final section in _sectionKeys.entries)
        section.key: prefs.getString(section.value) == null
            ? null
            : jsonDecode(prefs.getString(section.value)!),
    };
    final media = await _media.exportJson();
    final availableIds = media.map((item) => item['id']).toSet();
    final method = sections['method'] == null
        ? MethodProgress()
        : MethodProgress.fromJson(_map(sections['method']));
    final practice = sections['practice'] == null
        ? <PracticeRecord>[]
        : _list(sections['practice'])
              .map((item) => PracticeRecord.fromJson(_map(item)))
              .toList();
    final unavailable = {
      ...method.attempts
          .map((attempt) => attempt.evidenceId)
          .whereType<String>(),
      ...practice.map((record) => record.evidenceId).whereType<String>(),
    }..removeAll(availableIds);
    return jsonEncode({
      'format': 'forge-dance',
      'version': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      ...sections,
      'theme': prefs.getString(Constants.themeModeKey),
      'media': media,
      'unavailableMediaIds': unavailable.toList()..sort(),
    });
  }

  Future<void> saveBackup({required Rect shareOrigin}) async {
    final bytes = Uint8List.fromList(utf8.encode(await exportJson()));
    final name =
        'forge-dance-${DateTime.now().toIso8601String().substring(0, 10)}.json';
    final file = XFile.fromData(
      bytes,
      mimeType: 'application/json',
      name: name,
    );
    if (kIsWeb) {
      await file.saveTo(name);
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await SharePlus.instance.share(
        ShareParams(
          files: [file],
          fileNameOverrides: [name],
          sharePositionOrigin: shareOrigin,
        ),
      );
    } else {
      final target = await getSaveLocation(suggestedName: name);
      if (target != null) await file.saveTo(target.path);
    }
  }

  Future<Map<String, Object?>?> pickBackup() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'FORGE backup',
          extensions: ['json'],
          mimeTypes: ['application/json'],
        ),
      ],
    );
    if (file == null) return null;
    if (await file.length() > maxBackupBytes) {
      throw const FormatException('Backup exceeds the 150 MiB limit.');
    }
    return validateJson(await file.readAsString());
  }

  /// Validate every section and evidence reference before changing any storage.
  static Map<String, Object?> validateJson(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic> ||
        decoded['format'] != 'forge-dance' ||
        decoded['version'] != 1) {
      throw const FormatException('Unsupported FORGE backup format.');
    }
    final data = Map<String, Object?>.from(decoded);
    for (final key in [
      ..._sectionKeys.keys,
      'theme',
      'media',
      'unavailableMediaIds',
    ]) {
      if (!data.containsKey(key)) {
        throw FormatException('Missing backup section: $key');
      }
    }
    final profileData = data['profile'];
    if (profileData != null) {
      final profile = Profile.fromJson(_map(profileData));
      if ((profile.xp ?? 0) < 0 || (profile.streakCount ?? 0) < 0) {
        throw const FormatException('Invalid profile progress.');
      }
    }
    if (data['lessons'] != null) {
      for (final entry in _map(data['lessons']).entries) {
        final lesson = LessonProgress.fromJson(_map(entry.value));
        if (lesson.lessonId != entry.key ||
            lesson.lessonId.isEmpty ||
            !lesson.progress.isFinite ||
            lesson.progress < 0 ||
            lesson.progress > 1 ||
            (lesson.awardedXp ?? 0) < 0) {
          throw const FormatException('Invalid lesson progress.');
        }
      }
    }
    if (data['workouts'] != null) {
      for (final entry in _map(data['workouts']).entries) {
        final session = WorkoutSession.fromJson(_map(entry.value));
        if (session.docKey != entry.key ||
            session.workoutId.isEmpty ||
            DateTime.tryParse(session.date) == null ||
            (session.awardedXp ?? 0) < 0) {
          throw const FormatException('Invalid workout history.');
        }
      }
    }
    final method = data['method'] == null
        ? MethodProgress()
        : MethodProgress.fromJson(_map(data['method']));
    final practice = data['practice'] == null
        ? <PracticeRecord>[]
        : _list(data['practice'])
              .map((entry) => PracticeRecord.fromJson(_map(entry)))
              .toList();
    if (practice.map((record) => record.id).toSet().length != practice.length) {
      throw const FormatException('Duplicate practice records.');
    }
    if (data['practicePreferences'] != null) {
      PracticePreferences.fromJson(_map(data['practicePreferences']));
    }
    if (data['programmes'] != null) {
      ProgrammeRepository.validateJson(_list(data['programmes']));
    }
    final theme = data['theme'];
    if (theme != null && !['system', 'light', 'dark'].contains(theme)) {
      throw const FormatException('Invalid appearance preference.');
    }
    final media = _list(data['media']);
    MediaRepository.validateJson(media);
    final mediaIds = media.map((item) => _map(item)['id']).toSet();
    final missing = {
      ...method.attempts
          .map((attempt) => attempt.evidenceId)
          .whereType<String>(),
      ...practice.map((record) => record.evidenceId).whereType<String>(),
    }..removeAll(mediaIds);
    final declaredMissing = _list(data['unavailableMediaIds']);
    if (declaredMissing.any((id) => id is! String) ||
        declaredMissing.toSet().length != declaredMissing.length ||
        !setEquals(missing, declaredMissing.toSet())) {
      throw const FormatException(
        'Backup contains undeclared missing private media.',
      );
    }
    return data;
  }

  /// A failed write rolls back all previously written sections, including media.
  /// The caller blocks navigation/mutations while this local replacement runs.
  Future<void> restore(Map<String, Object?> input) async {
    if (_restoring) throw StateError('A restore is already in progress.');
    final data = validateJson(jsonEncode(input));
    _restoring = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final original = {
        for (final key in [..._sectionKeys.values, Constants.themeModeKey])
          key: prefs.getString(key),
      };
      final originalMedia = await _media.exportJson();
      try {
        await _media.replaceFromJson(_list(data['media']));
        for (final section in _sectionKeys.entries) {
          final value = data[section.key];
          await _write(
            prefs,
            section.value,
            value == null ? null : jsonEncode(value),
          );
        }
        await _write(prefs, Constants.themeModeKey, data['theme'] as String?);
      } catch (error) {
        try {
          await _media.replaceFromJson(originalMedia);
          for (final entry in original.entries) {
            await _write(prefs, entry.key, entry.value);
          }
        } catch (rollbackError) {
          throw StateError(
            'Restore failed ($error), and rollback failed ($rollbackError). Keep your backup file and retry the restore.',
          );
        }
        rethrow;
      }
    } finally {
      _restoring = false;
    }
  }

  static Map<String, Object?> _map(Object? value) {
    if (value is! Map<String, dynamic>) {
      throw const FormatException('Expected an object.');
    }
    return Map<String, Object?>.from(value);
  }

  static List<Object?> _list(Object? value) {
    if (value is! List) throw const FormatException('Expected a list.');
    return List<Object?>.from(value);
  }

  static Future<void> _write(
    SharedPreferences prefs,
    String key,
    String? value,
  ) async {
    final saved = value == null
        ? await prefs.remove(key)
        : await prefs.setString(key, value);
    if (!saved) throw StateError('Local storage could not save $key.');
  }
}
