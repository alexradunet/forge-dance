import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import 'programme_catalog.dart';

part 'programme_repository.g.dart';

@Riverpod(keepAlive: true)
ProgrammeRepository programmeRepository(Ref ref) => ProgrammeRepository();

/// Stores only enrolment. Lesson records remain the sole lesson progress source.
class ProgrammeRepository {
  ProgrammeRepository({
    Future<String?> Function(String key)? readString,
    Future<bool> Function(String key, String value)? writeString,
  }) : _readString = readString ?? _readPreference,
       _writeString = writeString ?? _writePreference;

  final Future<String?> Function(String key) _readString;
  final Future<bool> Function(String key, String value) _writeString;
  static Future<void> _pending = Future<void>.value();

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

  static Set<String> validateJson(List<Object?> json) {
    final known = forgeProgrammes.map((programme) => programme.id).toSet();
    final ids = <String>{};
    for (final value in json) {
      if (value is! String || !known.contains(value) || !ids.add(value)) {
        throw const FormatException('Invalid or duplicate programme enrolment');
      }
    }
    return Set.unmodifiable(ids);
  }

  Future<Set<String>> getEnrolledIds() async {
    await _pending;
    return _readEnrolledIds();
  }

  Future<Set<String>> _readEnrolledIds() async {
    final encoded = await _readString(Constants.programmeEnrolmentsKey);
    if (encoded == null) return const {};
    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      throw const FormatException('Programme enrolments must be a list');
    }
    return validateJson(decoded.cast<Object?>());
  }

  Future<List<String>> exportJson() async =>
      (await getEnrolledIds()).toList()..sort();

  Future<void> enrol(String id) => _enqueue(() async {
    final ids = {...await _readEnrolledIds(), id};
    await _save(validateJson(ids.toList()));
  });

  Future<void> leave(String id) => _enqueue(() async {
    final ids = {...await _readEnrolledIds()}..remove(id);
    await _save(ids);
  });

  Future<void> replaceFromJson(List<Object?> json) {
    final validated = validateJson(json);
    return _enqueue(() => _save(validated));
  }

  Future<void> _save(Set<String> ids) async {
    final saved = await _writeString(
      Constants.programmeEnrolmentsKey,
      jsonEncode(ids.toList()..sort()),
    );
    if (!saved) throw StateError('Programme enrolments could not be saved');
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    final result = _pending.then((_) => operation());
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }
}
