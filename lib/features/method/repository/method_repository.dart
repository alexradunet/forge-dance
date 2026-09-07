import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../model/forge_method.dart';

part 'method_repository.g.dart';

@Riverpod(keepAlive: true)
MethodRepository methodRepository(Ref ref) => MethodRepository();

class MethodRepository {
  static Future<void> _pending = Future.value();
  static bool _needsReload = false;

  Future<MethodProgress> get() async {
    await _pending;
    return _read();
  }

  Future<MethodProgress> _read() async {
    final preferences = await SharedPreferences.getInstance();
    if (_needsReload) {
      await preferences.reload();
      _needsReload = false;
    }
    final stored = preferences.getString(Constants.methodProgressKey);
    if (stored == null) return MethodProgress();
    final json = jsonDecode(stored);
    if (json is! Map<String, Object?>) {
      throw const FormatException('Invalid method progress.');
    }
    return MethodProgress.fromJson(json);
  }

  Future<MethodProgress> recordAssessment(AssessmentAttempt attempt) =>
      _serialize(() async {
        validateAssessmentAttempt(attempt);
        final current = await _read();
        for (final existing in current.attempts) {
          if (existing.id != attempt.id) continue;
          if (jsonEncode(existing.toJson()) == jsonEncode(attempt.toJson())) {
            return current;
          }
          throw const FormatException(
            'An assessment ID cannot overwrite historical evidence.',
          );
        }
        final updated = MethodProgress(
          attempts: [...current.attempts, attempt],
        );
        await _save(updated);
        return updated;
      });

  Future<void> replaceFromJson(Map<String, Object?> json) {
    final validated = MethodProgress.fromJson(json);
    return _serialize(() => _save(validated));
  }

  Future<void> _save(MethodProgress progress) async {
    final preferences = await SharedPreferences.getInstance();
    try {
      final saved = await preferences.setString(
        Constants.methodProgressKey,
        jsonEncode(progress.toJson()),
      );
      if (!saved) {
        throw StateError('Method progress could not be saved on this device.');
      }
    } catch (_) {
      // Legacy preferences update their cache before the platform write. A
      // retry must consult durable storage rather than accept that cached award.
      _needsReload = true;
      rethrow;
    }
  }

  Future<T> _serialize<T>(Future<T> Function() operation) {
    final result = _pending.then((_) => operation());
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }
}
