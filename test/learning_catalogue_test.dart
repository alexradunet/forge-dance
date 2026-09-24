import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/learn/repository/learning_catalogue.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';

void main() {
  test(
    'one catalogue retains every lesson without duplicate foundation modules',
    () {
      final catalogue = learningCatalogue('', allModules);
      expect(
        catalogue.modules.any((m) => commonFoundationModules.contains(m)),
        isFalse,
      );
      final covered = {
        for (final p in catalogue.programmes)
          for (final s in p.sessions) s.lessonId,
        for (final m in catalogue.modules)
          for (final l in m.lessons) l.id,
      };
      expect(
        covered,
        containsAll(allModules.expand((m) => m.lessons.map((l) => l.id))),
      );
    },
  );

  test('search resolves contained foundation modules and lessons to paths', () {
    final results = learningCatalogue('  READY BODY  ', allModules);
    expect(results.modules, isEmpty);
    expect(
      results.programmes.map((p) => p.id),
      containsAll(['find-the-beat', 'movement-foundations']),
    );
    expect(
      learningCatalogue('Bases & Breath', allModules).programmes,
      isNotEmpty,
    );
    expect(learningCatalogue('no such path', allModules).programmes, isEmpty);
    expect(learningCatalogue('no such path', allModules).modules, isEmpty);
  });
}
