import 'dart:convert';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/features/method/model/forge_method.dart';
import 'package:forge_dance/features/home/presentation/pages/home_page.dart';
import 'package:forge_dance/features/explore/presentation/pages/explore_page.dart';
import 'package:forge_dance/features/programmes/repository/programme_catalog.dart';
import 'package:forge_dance/features/programmes/repository/programme_repository.dart';
import 'package:forge_dance/features/movement_teacher/prototype/ui/motion_lab_page.dart';
import 'package:forge_dance/features/profile/ui/view_model/profile_view_model.dart';
import 'package:forge_dance/features/stats/ui/view_model/user_stats_provider.dart';
import 'package:forge_dance/features/learn/ui/view_model/learn_view_model.dart';
import 'package:forge_dance/features/method/ui/method_view_model.dart';
import 'package:forge_dance/features/practice/ui/practice_view_model.dart';
import 'package:forge_dance/features/programmes/ui/programmes_view_model.dart';
import 'package:forge_dance/features/method/ui/method_page.dart';
import 'package:forge_dance/features/practice/model/practice.dart';
import 'package:forge_dance/features/practice/repository/practice_repository.dart';
import 'package:forge_dance/features/practice/repository/practice_planner.dart';
import 'package:forge_dance/features/practice/ui/practice_log_page.dart';
import 'package:forge_dance/features/practice/ui/practice_page.dart';
import 'package:forge_dance/features/practice_player/ui/practice_player_page.dart';
import 'package:forge_dance/features/profile/presentation/pages/level_progression_page.dart';
import 'package:forge_dance/features/programmes/ui/programmes_page.dart';
import 'package:forge_dance/features/settings/presentation/pages/data_transfer_page.dart';
import 'package:forge_dance/features/vocabulary/repository/vocabulary_repository.dart';
import 'package:forge_dance/features/vocabulary/ui/vocabulary_entry_page.dart';
import 'package:forge_dance/generated/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CatalogueLoader extends AssetLoader {
  _CatalogueLoader(this.catalogue);
  final Map<String, dynamic> catalogue;
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async =>
      catalogue;
}

Future<void> _pumpFeature(
  WidgetTester tester,
  Widget page, {
  double textScale = 1,
  List<PracticeRecord> records = const [],
}) async {
  SharedPreferences.setMockInitialValues({});
  await tester.runAsync(EasyLocalization.ensureInitialized);
  final catalogue = await tester.runAsync(
    () async =>
        jsonDecode(await rootBundle.loadString('assets/translations/en.json'))
            as Map<String, dynamic>,
  );
  final container = await tester.runAsync(() async {
    final repository = PracticeRepository();
    for (final record in records) {
      await repository.record(record);
    }
    final result = ProviderContainer(
      overrides: [
        dailyPracticeDateProvider.overrideWithValue(DateTime(2026, 9, 7)),
      ],
    );
    result.listen(profileViewModelProvider, (_, _) {});
    result.listen(userStatsProvider, (_, _) {});
    result.listen(methodViewModelProvider, (_, _) {});
    result.listen(learnViewModelProvider, (_, _) {});
    result.listen(practiceViewModelProvider, (_, _) {});
    result.listen(practicePreferencesViewModelProvider, (_, _) {});
    result.listen(programmesViewModelProvider, (_, _) {});
    await Future.wait([
      result.read(profileViewModelProvider.future),
      result.read(userStatsProvider.future),
      result.read(methodViewModelProvider.future),
      result.read(learnViewModelProvider.future),
      result.read(practiceViewModelProvider.future),
      result.read(practicePreferencesViewModelProvider.future),
      result.read(programmesViewModelProvider.future),
    ]);
    return result;
  });
  addTearDown(container!.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: EasyLocalization(
        supportedLocales: const [Locale('en')],
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        saveLocale: false,
        path: 'assets/translations',
        assetLoader: _CatalogueLoader(catalogue!),
        child: Builder(
          builder: (context) => MaterialApp(
            theme: AppThemes.light,
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
            home: page,
          ),
        ),
      ),
    ),
  );
  // Discovery contains remote thumbnails with repeating loading placeholders.
  // Don't wait for a network image to settle in a widget test.
  if (page is HomePage || page is ExplorePage) {
    await tester.pump(const Duration(seconds: 1));
  } else {
    await tester.pumpAndSettle();
  }
}

double _contrast(Color a, Color b) =>
    (math.max(a.computeLuminance(), b.computeLuminance()) + 0.05) /
    (math.min(a.computeLuminance(), b.computeLuminance()) + 0.05);

void _expectDarkScreen(WidgetTester tester, Widget page) {
  final root = find.byWidget(page);
  final scaffoldFinder = find
      .descendant(of: root, matching: find.byType(Scaffold))
      .first;
  final scaffold = tester.widget<Scaffold>(scaffoldFinder);
  final background =
      scaffold.backgroundColor ??
      Theme.of(tester.element(scaffoldFinder)).scaffoldBackgroundColor;
  expect(
    background.computeLuminance(),
    lessThan(0.1),
    reason: 'Product pages stay immersive under a light host.',
  );

  for (final element
      in find
          .descendant(of: root, matching: find.byType(Material))
          .evaluate()) {
    final material = element.widget as Material;
    if (material.type != MaterialType.canvas &&
        material.type != MaterialType.card) {
      continue;
    }
    final color = material.color ?? Theme.of(element).canvasColor;
    if (color.a < 0.95) continue;
    expect(
      color.computeLuminance(),
      lessThan(0.1),
      reason: 'Cards and page surfaces must not fall back to white.',
    );
  }

  for (final element
      in find
          .descendant(of: root, matching: find.byType(RichText))
          .hitTestable()
          .evaluate()) {
    final richText = element.widget as RichText;
    final foreground = richText.text.style?.color;
    var disabled = false;
    element.visitAncestorElements((ancestor) {
      final widget = ancestor.widget;
      if (widget is ButtonStyleButton &&
          widget.onPressed == null &&
          widget.onLongPress == null) {
        disabled = true;
      }
      return !disabled;
    });
    if (foreground == null ||
        foreground.a < 0.99 ||
        disabled ||
        richText.text.toPlainText().trim().isEmpty) {
      continue;
    }
    var backing = background;
    element.visitAncestorElements((ancestor) {
      final widget = ancestor.widget;
      final color = widget is Material
          ? widget.color
          : widget is ColoredBox
          ? widget.color
          : null;
      if (color != null && color.a >= 0.95) {
        backing = color;
        return false;
      }
      return true;
    });
    // Chips paint their fill inside RawChip rather than on a Material ancestor.
    element.visitAncestorElements((ancestor) {
      final widget = ancestor.widget;
      if (widget is FilterChip) {
        final fill = widget.selected
            ? widget.selectedColor
            : widget.backgroundColor;
        if (fill != null) backing = Color.alphaBlend(fill, backing);
        return false;
      }
      return true;
    });
    expect(
      _contrast(foreground, backing),
      greaterThanOrEqualTo(4.5),
      reason:
          'Visible enabled text must remain readable: ${richText.text.toPlainText()}',
    );
  }
  expect(tester.takeException(), isNull);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final displayFont = FontLoader(AppTypography.displayFamily)
      ..addFont(rootBundle.load('assets/google_fonts/BebasNeue-Regular.ttf'));
    final bodyFont = FontLoader(AppTypography.bodyFamily)
      ..addFont(rootBundle.load('assets/google_fonts/Inter-Variable.ttf'));
    await Future.wait([displayFont.load(), bodyFont.load()]);
  });
  // Add new public product screens here; this tests rendered output, not source syntax.
  final screens = <String, Widget Function()>{
    'Home cypher': () => const HomePage(),
    'Learn discovery': () => const ExplorePage(),
    'Motion lab prototype': () => const MotionLabPage(),
    'Method overview': () => const MethodPage(),
    'Method category': () =>
        const MethodPage(initialCategory: ForgeCategory.rhythm),
    'Assessment form': () =>
        const MethodPage(initialAssessmentId: 'rhythm-1-v1'),
    'Daily practice': () => const PracticePage(),
    'Practice history': () => const PracticeLogPage(),
    'Practice player': () => PracticePlayerPage(
      block: buildPracticePlan(
        date: DateTime(2026, 9, 7),
        progress: MethodProgress(),
        minutes: 20,
        gentle: false,
        includeConditioning: false,
      ).blocks.first,
    ),
    'Programmes': () => const ProgrammesPage(),
    'Belt progression': () => const LevelProgressionPage(),
    'Backup and restore': () => const DataTransferPage(),
    'Movement reference': () => VocabularyEntryPage(
      entry: const VocabularyRepository().byId('bounce')!,
      onBack: () {},
    ),
  };

  for (final entry in screens.entries) {
    testWidgets(
      '${entry.key} preserves dark readable surfaces under a light host',
      (tester) async {
        final page = entry.value();
        await _pumpFeature(tester, page);
        _expectDarkScreen(tester, page);
      },
    );
  }

  for (final width in [320.0, 1024.0]) {
    testWidgets('Learn search, empty state and clear reflow at $width', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const page = ExplorePage();
      await _pumpFeature(tester, page, textScale: 2);
      _expectDarkScreen(tester, page);
      final input = find.byType(TextField);
      await tester.ensureVisible(input);
      await tester.enterText(input, '  READY BODY  ');
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(FgProgramCard), findsOneWidget);
      expect(find.text('READY BODY'), findsOneWidget);
      final preview = tester.widget<FgProgramCard>(find.byType(FgProgramCard));
      expect(preview.locked, isFalse);
      expect(
        preview.details,
        LocaleKeys.lessonsCompletedOf.tr(args: ['0', '3']),
      );
      await tester.enterText(input, 'no such dance module');
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(FgProgramCard), findsNothing);
      final empty = find.text(LocaleKeys.noResults.tr());
      await tester.ensureVisible(empty);
      expect(empty.hitTestable(), findsOneWidget);
      _expectDarkScreen(tester, page);
      final clear = find.byTooltip(LocaleKeys.clearSearch.tr());
      await tester.ensureVisible(clear);
      await tester.tap(clear);
      await tester.pump(const Duration(seconds: 1));
      expect(tester.widget<TextField>(input).controller!.text, isEmpty);
      expect(find.byType(FgProgramCard), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Programme disclosure and enrolment reflow at $width', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const page = ProgrammesPage();
      await _pumpFeature(tester, page, textScale: 2);
      _expectDarkScreen(tester, page);
      expect(find.text(LocaleKeys.programmesIntroduction.tr()), findsNothing);
      final details = find.text(LocaleKeys.detailsLearnMore.tr());
      await tester.ensureVisible(details);
      await tester.pumpAndSettle();
      await tester.tap(details);
      await tester.pumpAndSettle();
      final introduction = find.text(LocaleKeys.programmesIntroduction.tr());
      await tester.ensureVisible(introduction);
      await tester.pumpAndSettle();
      expect(introduction, findsOneWidget);
      _expectDarkScreen(tester, page);
      await tester.ensureVisible(details);
      await tester.pumpAndSettle();
      await tester.tap(details);
      await tester.pumpAndSettle();
      final card = find.byKey(
        const ValueKey('programme-preview-find-the-beat'),
      );
      final action = find.descendant(
        of: card,
        matching: find.text(LocaleKeys.programmesView.tr()),
      );
      await tester.ensureVisible(action);
      await tester.pumpAndSettle();
      expect(action.hitTestable(), findsOneWidget);
      await tester.tap(action);
      await tester.pumpAndSettle();
      final start = find.widgetWithText(
        FgButton,
        LocaleKeys.programmesStart.tr(),
      );
      await tester.ensureVisible(start);
      await tester.pumpAndSettle();
      expect(tester.widget<FgButton>(start).isEnabled, isTrue);
      await tester.runAsync(() async {
        await tester.tap(start);
        expect(
          await ProgrammeRepository().getEnrolledIds(),
          contains('find-the-beat'),
        );
      });
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.programmesLeave.tr()), findsOneWidget);
      await tester.scrollUntilVisible(find.byType(BackButton), -200);
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(tester.widget<FgProgramCard>(card).isSelected, isTrue);
      expect(
        find.descendant(
          of: card,
          matching: find.text(LocaleKeys.programmesContinue.tr()),
        ),
        findsOneWidget,
      );
      _expectDarkScreen(tester, page);
    });
  }

  testWidgets(
    'locked programme remains inspectable without bypassing prerequisites',
    (tester) async {
      await _pumpFeature(tester, const ProgrammesPage());
      final card = find.byKey(
        const ValueKey('programme-preview-move-with-control'),
      );
      expect(tester.widget<FgProgramCard>(card).locked, isTrue);
      final action = find.descendant(
        of: card,
        matching: find.text(LocaleKeys.programmesView.tr()),
      );
      await tester.ensureVisible(action);
      await tester.pumpAndSettle();
      expect(action.hitTestable(), findsOneWidget);
      await tester.tap(action);
      await tester.pumpAndSettle();
      final start = find.widgetWithText(
        FgButton,
        LocaleKeys.programmesStart.tr(),
      );
      expect(tester.widget<FgButton>(start).isEnabled, isFalse);
      expect(
        find.text(LocaleKeys.programmesPrerequisiteHint.tr()),
        findsOneWidget,
      );
      final details = find.text(LocaleKeys.detailsProgramme.tr());
      await tester.ensureVisible(details);
      await tester.pumpAndSettle();
      await tester.tap(details);
      await tester.pumpAndSettle();
      final description = find.text(forgeProgrammes[1].description);
      await tester.ensureVisible(description);
      await tester.pumpAndSettle();
      expect(description, findsOneWidget);
      _expectDarkScreen(
        tester,
        tester.widget(find.byType(FgImmersiveScaffold).last),
      );
    },
  );

  testWidgets('Home poster and complete explanation reflow at large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const page = HomePage();
    await _pumpFeature(tester, page, textScale: 2);
    _expectDarkScreen(tester, page);
    final action = find.widgetWithText(
      FgButton,
      LocaleKeys.forgeTodayPractice.tr(),
    );
    await tester.ensureVisible(action);
    await tester.pump(const Duration(seconds: 1));
    expect(action.hitTestable(), findsOneWidget);
    expect(find.text(LocaleKeys.forgeCoreSubtitle.tr()), findsNothing);
    final disclosure = find.text(LocaleKeys.detailsLearnMore.tr());
    await tester.ensureVisible(disclosure);
    await tester.tap(disclosure);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(LocaleKeys.forgeCoreSubtitle.tr()), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('motion lab is explicit, controllable and pauses in background', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const page = MotionLabPage();
    await _pumpFeature(tester, page);
    expect(find.text(LocaleKeys.motionLabWarning.tr()), findsOneWidget);
    final play = find.widgetWithText(FgButton, LocaleKeys.motionLabPlay.tr());
    await tester.ensureVisible(play);
    await tester.tap(play);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(LocaleKeys.motionLabPause.tr()), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.text(LocaleKeys.motionLabPlay.tr()), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final back = find.widgetWithText(
      FgFilterChip,
      LocaleKeys.motionLabBack.tr(),
    );
    await tester.ensureVisible(back);
    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(find.text('180°'), findsOneWidget);
    final details = find.text(LocaleKeys.motionLabAbout.tr());
    await tester.ensureVisible(details);
    await tester.tap(details);
    await tester.pumpAndSettle();
    expect(find.text(LocaleKeys.motionLabScope.tr()), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'motion lab controls and limitations remain reachable at large text',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const page = MotionLabPage();
      await _pumpFeature(tester, page, textScale: 2);
      _expectDarkScreen(tester, page);
      final details = find.text(LocaleKeys.motionLabAbout.tr());
      await tester.scrollUntilVisible(details, 300);
      await tester.tap(details);
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.motionLabScope.tr()), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Method explanations expand without hiding the category action', (
    tester,
  ) async {
    const page = MethodPage();
    await _pumpFeature(tester, page);
    expect(find.text(LocaleKeys.methodCurrentHelp.tr()), findsNothing);
    expect(find.text(ForgeCategory.rhythm.label), findsOneWidget);
    await tester.tap(find.text(LocaleKeys.detailsAboutMethod.tr()));
    await tester.pumpAndSettle();
    expect(find.text(LocaleKeys.methodCurrentHelp.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.methodSupportHelp.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.forgeCriteriaProvisional.tr()), findsOneWidget);
    await tester.tap(find.text(LocaleKeys.detailsAboutMethod.tr()));
    await tester.pumpAndSettle();
    await tester.tap(find.text(ForgeCategory.rhythm.label));
    await tester.pumpAndSettle();
    expect(find.text(assessmentById('rhythm-1-v1').title), findsOneWidget);
  });

  testWidgets(
    'assessment details preserve the full adaptation and visible criteria',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final assessment = assessmentById('rhythm-1-v1');
      await _pumpFeature(
        tester,
        const MethodPage(initialAssessmentId: 'rhythm-1-v1'),
      );
      expect(find.text(assessment.instructions), findsOneWidget);
      for (final criterion in assessment.criteria) {
        expect(find.text(criterion.text), findsOneWidget);
      }
      expect(find.text(assessment.adaptation), findsNothing);
      final details = find.text(LocaleKeys.detailsAdaptations.tr());
      await tester.ensureVisible(details);
      await tester.tap(details);
      await tester.pumpAndSettle();
      expect(find.text(assessment.adaptation), findsOneWidget);
    },
  );

  testWidgets(
    'practice leads with its action while optional settings remain reachable',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pumpFeature(tester, const PracticePage());
      final plan = buildPracticePlan(
        date: DateTime(2026, 9, 7),
        progress: MethodProgress(),
        minutes: 20,
        gentle: false,
        includeConditioning: false,
      );
      expect(find.text(plan.title), findsOneWidget);
      expect(
        find.text(
          LocaleKeys.dailyPracticePrescription.tr(args: ['White', '20']),
        ),
        findsOneWidget,
      );
      final practice = find
          .widgetWithText(FgButton, LocaleKeys.practicePlay.tr())
          .first;
      expect(practice.hitTestable(), findsOneWidget);
      expect(find.text(LocaleKeys.compactGentle.tr()), findsNothing);
      final options = find.text(
        LocaleKeys.compactPracticeOptions.tr(
          args: [LocaleKeys.practiceStanding.tr()],
        ),
      );
      await tester.tap(options);
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.compactGentle.tr()), findsOneWidget);
      expect(
        find.widgetWithText(FgFilterChip, LocaleKeys.practiceSeated.tr()),
        findsOneWidget,
      );
      await tester.tap(options);
      await tester.pumpAndSettle();
      expect(practice.hitTestable(), findsOneWidget);
    },
  );

  testWidgets('daily theme and adaptations stay usable with large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const page = PracticePage();
    await _pumpFeature(tester, page, textScale: 2);
    _expectDarkScreen(tester, page);
    final plan = buildPracticePlan(
      date: DateTime(2026, 9, 7),
      progress: MethodProgress(),
      minutes: 20,
      gentle: false,
      includeConditioning: false,
    );
    final guidance = find.byKey(
      ValueKey('practice-adaptations-${plan.blocks.first.id}'),
    );
    final guidanceTitle = find.descendant(
      of: guidance,
      matching: find.text(LocaleKeys.detailsAdaptations.tr()),
    );
    await tester.scrollUntilVisible(guidanceTitle, 200);
    await tester.pumpAndSettle();
    await tester.ensureVisible(guidanceTitle);
    await tester.pumpAndSettle();
    await tester.tap(guidanceTitle);
    await tester.pumpAndSettle();
    expect(find.text(plan.blocks.first.adaptation), findsOneWidget);
    _expectDarkScreen(tester, page);
    final practice = find
        .widgetWithText(FgButton, LocaleKeys.practicePlay.tr())
        .first;
    await tester.ensureVisible(practice);
    await tester.pumpAndSettle();
    await tester.tap(practice);
    await tester.pumpAndSettle();
    expect(find.byType(PracticePlayerPage), findsOneWidget);
    _expectDarkScreen(
      tester,
      tester.widget<PracticePlayerPage>(find.byType(PracticePlayerPage)),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'daily history retains the scheduled day and color through a root dialog',
    (tester) async {
      final plan = buildPracticePlan(
        date: DateTime(2026, 9, 7),
        progress: MethodProgress(),
        minutes: 20,
        gentle: false,
        includeConditioning: false,
      );
      final block = plan.blocks.first;
      final record = PracticeRecord(
        id: 'daily-history',
        blockId: block.id,
        title: block.title,
        lessonId: block.lessonId,
        workoutId: block.workoutId,
        workoutDate: block.workoutDate,
        level: block.level,
        performedAt: DateTime(2026, 9, 8),
        durationSeconds: 90,
        bpm: block.bpm,
        attempts: 1,
        difficulty: 3,
      );
      const page = PracticeLogPage();
      await _pumpFeature(tester, page, records: [record]);
      expect(
        find.text(
          LocaleKeys.dailyPracticeWorkoutDate.tr(
            args: [DateFormat.yMMMd('en').format(DateTime(2026, 9, 7))],
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.text(LocaleKeys.dailyPracticeVariation.tr(args: ['White'])),
        findsOneWidget,
      );
      await tester.tap(
        find.widgetWithText(FgButton, LocaleKeys.practiceDelete.tr()),
      );
      await tester.pumpAndSettle();
      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      expect(find.text(LocaleKeys.practiceDeleteBody.tr()), findsOneWidget);
      expect(
        Theme.of(tester.element(dialog)).colorScheme.surface.computeLuminance(),
        lessThan(0.1),
      );
      await tester.tap(find.text(LocaleKeys.practiceCancel.tr()));
      await tester.pumpAndSettle();
      expect(find.text(block.title), findsOneWidget);
      _expectDarkScreen(tester, page);
    },
  );

  testWidgets(
    'backup actions lead while the complete export explanation stays available',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pumpFeature(tester, const DataTransferPage());
      expect(find.text(LocaleKeys.forgeTransferDescription.tr()), findsNothing);
      expect(
        find.text(LocaleKeys.forgeExportData.tr()).hitTestable(),
        findsOneWidget,
      );
      expect(
        find.text(LocaleKeys.forgeImportData.tr()).hitTestable(),
        findsOneWidget,
      );
      await tester.tap(find.text(LocaleKeys.detailsBackup.tr()));
      await tester.pumpAndSettle();
      expect(
        find.text(LocaleKeys.forgeTransferDescription.tr()),
        findsOneWidget,
      );
      expect(find.text(LocaleKeys.forgeRestoreWarning.tr()), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
