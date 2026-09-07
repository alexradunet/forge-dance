import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../model/practice.dart';

part 'practice_repository.g.dart';

@Riverpod(keepAlive: true)
PracticeRepository practiceRepository(Ref ref) => PracticeRepository();

class PracticeRepository {
  PracticeRepository({
    Future<String?> Function(String key)? readString,
    Future<bool> Function(String key, String value)? writeString,
  }) : _readString = readString ?? _readPreference,
       _writeString = writeString ?? _writePreference;

  final Future<String?> Function(String key) _readString;
  final Future<bool> Function(String key, String value) _writeString;

  // Shared by instances so a fresh repository cannot race an in-flight append.
  static Future<void> _writes = Future.value();

  static Future<String?> _readPreference(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);
  static Future<bool> _writePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final saved = await prefs.setString(key, value);
      if (!saved) await prefs.reload();
      return saved;
    } catch (_) {
      await prefs.reload();
      rethrow;
    }
  }

  Future<void> _serialize(Future<void> Function() operation) {
    final result = _writes.then((_) => operation());
    _writes = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  Future<List<PracticeRecord>> getAll() async {
    await _writes;
    return _readRecords();
  }

  Future<List<PracticeRecord>> _readRecords() async {
    final encoded = await _readString(Constants.practiceRecordsKey);
    if (encoded == null) return const [];
    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      throw const FormatException('Practice history is not a list.');
    }
    return validateImport(decoded.cast<Object?>());
  }

  static List<PracticeRecord> validateImport(List<Object?> json) {
    final records = <PracticeRecord>[];
    final ids = <String>{};
    for (final item in json) {
      if (item is! Map) {
        throw const FormatException('Malformed practice history.');
      }
      final record = PracticeRecord.fromJson(item.cast<String, Object?>());
      if (!ids.add(record.id)) {
        throw const FormatException('Duplicate practice record ID.');
      }
      records.add(record);
    }
    return List.unmodifiable(records);
  }

  Future<void> _saveRecords(List<PracticeRecord> records) async {
    if (!await _writeString(
      Constants.practiceRecordsKey,
      jsonEncode(records.map((record) => record.toJson()).toList()),
    )) {
      throw StateError('Practice history could not be saved. Please retry.');
    }
  }

  /// Retrying the same result is safe; a different attempt must have a new ID.
  Future<void> record(PracticeRecord record) => _serialize(() async {
    record.validate();
    final records = await _readRecords();
    final previous = records.where((item) => item.id == record.id).firstOrNull;
    if (previous != null) {
      if (jsonEncode(previous.toJson()) != jsonEncode(record.toJson())) {
        throw StateError(
          'This practice ID already belongs to a different result.',
        );
      }
      return;
    }
    await _saveRecords([...records, record]);
  });

  Future<void> updateReflection(PracticeRecord record) => _serialize(() async {
    record.validate();
    final records = await _readRecords();
    final previous = records.where((item) => item.id == record.id).firstOrNull;
    if (previous == null) throw StateError('Practice record no longer exists.');
    final allowed = previous.withReflection(
      notes: record.notes,
      difficulty: record.difficulty,
      evidenceId: record.evidenceId,
    );
    if (jsonEncode(allowed.toJson()) != jsonEncode(record.toJson())) {
      throw StateError('Only reflection, effort and evidence can be edited.');
    }
    await _saveRecords([
      for (final item in records)
        if (item.id == record.id) record else item,
    ]);
  });

  Future<void> delete(String id) => _serialize(() async {
    final records = await _readRecords();
    await _saveRecords(records.where((item) => item.id != id).toList());
  });

  Future<void> replaceFromJson(List<Object?> json) {
    final records = validateImport(json);
    return _serialize(() => _saveRecords(records));
  }

  Future<PracticePreferences> getPreferences() async {
    await _writes;
    final encoded = await _readString(Constants.practicePreferencesKey);
    if (encoded == null) return const PracticePreferences();
    final decoded = jsonDecode(encoded);
    if (decoded is! Map) {
      throw const FormatException('Malformed practice preferences.');
    }
    return PracticePreferences.fromJson(decoded.cast<String, Object?>());
  }

  Future<void> savePreferences(PracticePreferences preferences) {
    PracticePreferences.fromJson(preferences.toJson());
    return _serialize(() async {
      if (!await _writeString(
        Constants.practicePreferencesKey,
        jsonEncode(preferences.toJson()),
      )) {
        throw StateError('Practice choices could not be saved. Please retry.');
      }
    });
  }

  Future<void> replacePreferencesFromJson(Map<String, Object?> json) =>
      savePreferences(PracticePreferences.fromJson(json));
}
