import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/localization/app_locales.dart';

void main() {
  test('supported locales, translation assets, and generated keys agree', () {
    final translationFiles =
        Directory('assets/translations')
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.json'))
            .toList()
          ..sort((left, right) => left.path.compareTo(right.path));

    final assetLocales = translationFiles
        .map((file) => file.uri.pathSegments.last.replaceAll('.json', ''))
        .toSet();
    final supportedLocales = AppLocales.supported
        .map((locale) => locale.languageCode)
        .toSet();

    expect(assetLocales, supportedLocales);

    final translationKeys = <String>{};
    for (final file in translationFiles) {
      final json = jsonDecode(file.readAsStringSync());
      expect(json, isA<Map<String, Object?>>(), reason: file.path);

      final translations = json as Map<String, Object?>;
      expect(
        translations.values,
        everyElement(isA<String>()),
        reason: '${file.path} must contain string values only',
      );
      translationKeys.addAll(translations.keys);
    }

    final generatedSource = File('lib/generated/locale_keys.g.dart')
        .readAsStringSync();
    final generatedKeys = RegExp(r"static const \w+ = '([^']+)';")
        .allMatches(generatedSource)
        .map((match) => match.group(1)!)
        .toSet();

    expect(generatedKeys, translationKeys);
  });
}
