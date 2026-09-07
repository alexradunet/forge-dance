import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/vocabulary/model/vocabulary_entry.dart';
import 'package:forge_dance/features/vocabulary/repository/vocabulary_repository.dart';
import 'package:forge_dance/features/vocabulary/ui/vocabulary_page.dart';
import 'package:forge_dance/features/vocabulary/ui/vocabulary_entry_page.dart';
import 'package:forge_dance/features/vocabulary/ui/vocabulary_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const repository = VocabularyRepository();

  test('catalog references are unique and point to real lessons and terms', () {
    expect(
      repository.entries.map((entry) => entry.id).toSet().length,
      repository.entries.length,
    );
    for (final entry in repository.entries) {
      final module = allModules.singleWhere(
        (module) => module.id == entry.moduleId,
      );
      expect(
        module.lessons.any((lesson) => lesson.id == entry.lessonId),
        isTrue,
      );
      for (final related in entry.relatedIds) {
        expect(repository.byId(related), isNotNull);
      }
      expect(entry.practice, isNotEmpty);
      expect(entry.cue, isNotEmpty);
      expect(entry.commonMistake, isNotEmpty);
    }
    expect(repository.byId('missing'), isNull);
  });

  test('search normalizes aliases and combines kind and style filters', () {
    expect(
      repository.search(query: '  WEIGHT SHIFT ').single.id,
      'weight-transfer',
    );
    expect(
      repository.search(kind: VocabularyKind.move).map((entry) => entry.id),
      ['bounce', 'rock'],
    );
    expect(
      repository.search(kind: VocabularyKind.move, style: 'Foundations'),
      isEmpty,
    );
    expect(repository.search(query: 'no-such-term'), isEmpty);
    expect(repository.search(), hasLength(6));
  });

  testWidgets('search and filter intents update visible vocabulary', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppThemes.dark, home: const VocabularyPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'weight shift');
    await tester.pumpAndSettle();
    expect(find.text('Weight transfer'), findsOneWidget);
    expect(find.text('Bounce'), findsNothing);
    await tester.tap(find.widgetWithText(FgFilterChip, 'vocabularyMoves'));
    await tester.pumpAndSettle();
    expect(find.text('noResults'), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(VocabularyPage)),
    );
    expect(container.read(vocabularyViewModelProvider).query, 'weight shift');
    expect(tester.takeException(), isNull);
  });

  testWidgets('unexplored term remains readable at large text with path link', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppThemes.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: VocabularyEntryPage(
            entry: repository.byId('bounce')!,
            onBack: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('BOUNCE'), findsOneWidget);
    await tester.ensureVisible(find.text('vocabularyViewPath'));
    await tester.pumpAndSettle();
    expect(find.text('vocabularyViewPath'), findsOneWidget);
    expect(find.text('vocabularyViewLesson'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
