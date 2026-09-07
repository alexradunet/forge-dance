import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/settings/repository/portable_backup_repository.dart';

Map<String, Object?> emptyBackup() => {
  'format': 'forge-dance',
  'version': 1,
  'profile': null,
  'lessons': null,
  'workouts': null,
  'method': null,
  'practice': null,
  'practicePreferences': null,
  'programmes': null,
  'theme': null,
  'media': <Object?>[],
  'unavailableMediaIds': <String>[],
};

void main() {
  test('rejects future formats instead of silently dropping their fields', () {
    final backup = emptyBackup()..['version'] = 2;
    expect(
      () => PortableBackupRepository.validateJson(jsonEncode(backup)),
      throwsFormatException,
    );
  });

  test(
    'rejects missing history instead of treating it as an empty restore',
    () {
      final backup = emptyBackup()..remove('lessons');
      expect(
        () => PortableBackupRepository.validateJson(jsonEncode(backup)),
        throwsFormatException,
      );
    },
  );

  test(
    'rejects a lesson map that would credit completion to another lesson',
    () {
      final backup = emptyBackup()
        ..['lessons'] = {
          'common-ready-body-space-signals': {
            'lessonId': 'common-ready-body-body-map',
            'status': 'completed',
            'progress': 1.0,
          },
        };
      expect(
        () => PortableBackupRepository.validateJson(jsonEncode(backup)),
        throwsFormatException,
      );
    },
  );
}
