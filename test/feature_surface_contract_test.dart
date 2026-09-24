import 'dart:async';
import 'dart:convert';
import 'dart:ui' show SemanticsFlag, SemanticsAction;
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/constants/assets.dart';
import 'package:forge_dance/features/method/model/forge_method.dart';
import 'package:forge_dance/features/home/presentation/pages/home_page.dart';
import 'package:forge_dance/features/explore/presentation/pages/explore_page.dart';
import 'package:forge_dance/features/programmes/repository/programme_catalog.dart';
import 'package:forge_dance/features/programmes/repository/programme_repository.dart';
import 'package:forge_dance/features/movement_teacher/prototype/ui/motion_lab_page.dart';
import 'package:forge_dance/features/profile/ui/view_model/profile_view_model.dart';
import 'package:forge_dance/features/stats/ui/view_model/user_stats_provider.dart';
import 'package:forge_dance/features/stats/model/user_stats.dart';
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
import 'package:forge_dance/features/vocabulary/ui/vocabulary_page.dart';
import 'package:forge_dance/features/vocabulary/ui/vocabulary_view_model.dart';
import 'package:forge_dance/generated/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:forge_dance/routing/routes.dart';

import 'package:forge_dance/features/onboarding/ui/onboarding_screen.dart';
import 'package:forge_dance/features/onboarding/ui/splash_screen.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/repository/profile_repository.dart';
import 'package:forge_dance/features/profile/presentation/pages/profile_page.dart';
import 'package:forge_dance/features/profile/ui/account_info_screen.dart';
import 'package:forge_dance/features/profile/ui/appearances_screen.dart';
import 'package:forge_dance/features/profile/ui/widgets/level_item.dart';
import 'package:forge_dance/features/settings/presentation/pages/settings_page.dart';
import 'package:forge_dance/features/settings/repository/portable_backup_repository.dart';
import 'package:forge_dance/features/common/ui/providers/app_theme_mode_provider.dart';
import 'package:forge_dance/constants/constants.dart';

import 'package:forge_dance/features/learn/ui/module_view_screen.dart';
import 'package:forge_dance/features/learn/ui/lesson_player_screen.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/learn/model/lesson_progress.dart';
import 'package:forge_dance/features/learn/model/lesson.dart';
import 'package:forge_dance/features/learn/repository/progress_repository.dart';
import 'package:forge_dance/features/library/presentation/pages/collection_page.dart';
import 'package:forge_dance/features/stats/presentation/pages/stats_page.dart';
import 'package:forge_dance/features/method/repository/method_repository.dart';
import 'package:forge_dance/features/method/repository/method_catalog.dart';

import 'package:forge_dance/features/media/model/local_media.dart';
import 'package:forge_dance/features/media/repository/media_repository.dart';
import 'package:forge_dance/features/media/ui/evidence_picker.dart';
import 'package:forge_dance/features/media/ui/local_video_playback.dart';
import 'package:forge_dance/features/workout/presentation/pages/training_session_page.dart';
import 'package:forge_dance/features/workout/repository/session_repository.dart';
import 'package:forge_dance/features/workout/repository/workout_catalog.dart';
import 'package:forge_dance/features/workout/model/workout_session.dart';
import 'package:forge_dance/features/workout/ui/view_model/workout_view_model.dart';
import 'package:forge_dance/features/main/presentation/pages/main_screen.dart';
import 'package:forge_dance/routing/shell_navigation_observer.dart';
import 'package:forge_dance/features/common/ui/widgets/offline_container.dart';

import 'package:forge_dance/features/practice/ui/workout_session_page.dart';
import 'package:forge_dance/features/practice/model/workout_session.dart'
    as daily;

import 'support/workout_session_fixture.dart';

import 'package:forge_dance/features/practice_player/model/practice_clock.dart';

part 'workout_session_surface_contracts.dart';
part 'remaining_surface_contracts.dart';
part 'review_surface_contracts.dart';
part 'personal_surface_contracts.dart';
part 'learning_surface_contracts.dart';

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
  GoRouter? router,
  List<PracticeRecord> records = const [],
  ProfileRepository? profileRepository,
  PortableBackupRepository? backupRepository,
  Future<UserStats>? statsResult,
  Map<String, Object> initialPreferences = const {},
  MethodRepository? methodRepository,
  ProgressRepository? progressRepository,
  PracticeRepository? practiceRepository,
  Future<void> Function(ProviderContainer)? beforePump,
  bool settle = true,
  bool waitForLearning = true,
  MediaRepository? mediaRepository,
  LocalVideoPlayback Function()? playbackFactory,
  SessionRepository? sessionRepository,
  WorkoutViewModel Function()? workoutViewModel,
  ProgrammeRepository? programmeRepository,
  bool waitForWorkout = true,
  daily.WorkoutSession Function(
    PracticePlan,
    Future<void> Function(PracticeRecord),
  )?
  workoutSessionFactory,
}) async {
  SharedPreferences.setMockInitialValues(initialPreferences);
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
        if (workoutSessionFactory != null)
          workoutSessionFactoryProvider.overrideWith(
            (ref) =>
                (plan) => workoutSessionFactory(
                  plan,
                  ref.read(practiceViewModelProvider.notifier).record,
                ),
          ),
        if (programmeRepository != null)
          programmeRepositoryProvider.overrideWithValue(programmeRepository),
        mediaRepositoryProvider.overrideWithValue(
          mediaRepository ?? _ContractMediaRepository(),
        ),
        if (playbackFactory != null)
          localVideoPlaybackFactoryProvider.overrideWith(
            (_) => playbackFactory,
          ),
        if (sessionRepository != null)
          sessionRepositoryProvider.overrideWithValue(sessionRepository),
        if (workoutViewModel != null)
          workoutViewModelProvider.overrideWith(workoutViewModel),
        if (methodRepository != null)
          methodRepositoryProvider.overrideWithValue(methodRepository),
        if (progressRepository != null)
          progressRepositoryProvider.overrideWithValue(progressRepository),
        if (practiceRepository != null)
          practiceRepositoryProvider.overrideWithValue(practiceRepository),
        if (statsResult != null)
          userStatsProvider.overrideWith((_) => statsResult),
        if (profileRepository != null)
          profileRepositoryProvider.overrideWithValue(profileRepository),
        if (backupRepository != null)
          portableBackupRepositoryProvider.overrideWithValue(backupRepository),
        dailyPracticeDateProvider.overrideWithValue(DateTime(2026, 9, 7)),
      ],
    );
    result.listen(workoutViewModelProvider, (_, _) {});
    result.listen(appThemeModeProvider, (_, _) {});
    result.listen(profileViewModelProvider, (_, _) {});
    result.listen(userStatsProvider, (_, _) {});
    result.listen(methodViewModelProvider, (_, _) {});
    result.listen(learnViewModelProvider, (_, _) {});
    result.listen(practiceViewModelProvider, (_, _) {});
    result.listen(practicePreferencesViewModelProvider, (_, _) {});
    result.listen(programmesViewModelProvider, (_, _) {});
    await Future.wait([
      if (waitForWorkout) result.read(workoutViewModelProvider.future),
      result.read(appThemeModeProvider.future),
      result.read(profileViewModelProvider.future),
      if (statsResult == null && waitForLearning)
        result.read(userStatsProvider.future),
      result.read(methodViewModelProvider.future),
      if (waitForLearning) result.read(learnViewModelProvider.future),
      result.read(practiceViewModelProvider.future),
      result.read(practicePreferencesViewModelProvider.future),
      result.read(programmesViewModelProvider.future),
    ]);
    if (beforePump != null) await beforePump(result);
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
          builder: (context) {
            Widget scale(BuildContext context, Widget? child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            );
            if (router != null) {
              return MaterialApp.router(
                theme: AppThemes.light,
                locale: context.locale,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                builder: scale,
                routerConfig: router,
              );
            }
            return MaterialApp(
              theme: AppThemes.light,
              locale: context.locale,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              builder: scale,
              home: page,
            );
          },
        ),
      ),
    ),
  );
  // Explore still uses remote thumbnails. Home/Workout now use bundled photos.
  if (!settle || page is ExplorePage || statsResult != null) {
    await tester.pump(const Duration(seconds: 1));
  } else {
    await tester.pumpAndSettle();
  }
}

// Settle after scrolling: layout and lazy-sliver extents update on the next frame.
Future<void> _show(
  WidgetTester tester,
  Finder target, {
  double delta = 250,
}) async {
  await tester.scrollUntilVisible(
    target,
    delta,
    scrollable: find.byType(Scrollable).hitTestable().first,
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
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

  _expectReadableText(tester, root, background);
  expect(tester.takeException(), isNull);
}

void _expectReadableText(WidgetTester tester, Finder root, Color background) {
  for (final element
      in find
          .descendant(of: root, matching: find.byType(RichText))
          .hitTestable()
          .evaluate()) {
    final richText = element.widget as RichText;
    final foreground = richText.text.style?.color;
    var isIcon = false;
    element.visitAncestorElements((ancestor) {
      final widget = ancestor.widget;
      if (widget is Icon) isIcon = true;
      return true;
    });
    if (foreground == null || richText.text.toPlainText().trim().isEmpty) {
      continue;
    }
    var backing = background;
    final layers = <Color>[];
    element.visitAncestorElements((ancestor) {
      final widget = ancestor.widget;
      final color = widget is Material
          ? widget.color
          : widget is ColoredBox
          ? widget.color
          : widget is DecoratedBox && widget.decoration is BoxDecoration
          ? (widget.decoration as BoxDecoration).color
          : null;
      if (color != null) {
        layers.add(color);
        if (color.a == 1) return false;
      }
      return true;
    });
    for (final layer in layers.reversed) {
      backing = Color.alphaBlend(layer, backing);
    }
    // Chips paint their fill inside RawChip rather than on a Material ancestor.
    element.visitAncestorElements((ancestor) {
      final widget = ancestor.widget;
      if (widget is Badge &&
          widget.label != null &&
          find
              .descendant(
                of: find.byWidget(widget.label!),
                matching: find.byWidget(richText),
              )
              .evaluate()
              .contains(element)) {
        backing =
            widget.backgroundColor ?? Theme.of(ancestor).colorScheme.error;
        return false;
      }
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
      _contrast(Color.alphaBlend(foreground, backing), backing),
      greaterThanOrEqualTo(isIcon ? 3 : 4.5),
      reason:
          'Visible text (including disabled and alpha-composited states) must remain readable: ${richText.text.toPlainText()}',
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
    ..._remainingImmersiveScreens,
    ..._personalImmersiveScreens,
    ..._learningImmersiveScreens,
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
    'Vocabulary index': () => const VocabularyPage(),
    'Movement reference': () => VocabularyEntryPage(
      entry: const VocabularyRepository().byId('bounce')!,
      onBack: () {},
    ),
  };

  // Deliberately standard utility; selection must not coerce the host theme.
  testWidgets('Appearance normal light-host surface and default selection', (
    tester,
  ) async {
    await _pumpFeature(tester, const AppearancesScreen());
    expect(
      Theme.of(tester.element(find.byType(AppearancesScreen))).brightness,
      Brightness.light,
    );
    _expectAppearanceContrast(tester);
  });

  _workoutSessionSurfaceContracts();
  _personalSurfaceContracts();
  _learningSurfaceContracts();
  _remainingSurfaceContracts();
  _reviewSurfaceContracts();

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

  for (final width in [320.0, 1040.0]) {
    testWidgets(
      'Vocabulary filters, full definitions and recovery reflow at $width',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        const page = VocabularyPage();
        await _pumpFeature(tester, page, textScale: 2);
        _expectDarkScreen(tester, page);
        final input = find.byType(TextField);
        await _show(tester, input);
        await tester.enterText(input, '  WEIGHT SHIFT  ');
        await tester.pumpAndSettle();
        final definition = find.text(
          const VocabularyRepository().byId('weight-transfer')!.definition,
        );
        await _show(tester, definition);
        expect(definition.hitTestable(), findsOneWidget);
        final card = find.byKey(const ValueKey('vocabulary-weight-transfer'));
        expect(tester.widget<FgReferenceCard>(card).indexLabel, '06');
        final moves = find.widgetWithText(
          FgFilterChip,
          LocaleKeys.vocabularyMoves.tr(),
        );
        await _show(tester, moves, delta: -250);
        await tester.tap(moves);
        await tester.pumpAndSettle();
        final empty = find.text(LocaleKeys.noResults.tr());
        await _show(tester, empty);
        expect(empty.hitTestable(), findsOneWidget);
        _expectDarkScreen(tester, page);
        final reset = find
            .widgetWithText(FgButton, LocaleKeys.vocabularyResetFilters.tr())
            .first;
        await _show(tester, reset, delta: -250);
        await tester.tap(reset);
        await tester.pumpAndSettle();
        expect(tester.widget<TextField>(input).controller!.text, isEmpty);
        final styles = find.text(
          LocaleKeys.vocabularyStyleFilter.tr(
            args: [LocaleKeys.vocabularyAllStyles.tr()],
          ),
        );
        await _show(tester, styles, delta: -250);
        await tester.tap(styles);
        await tester.pumpAndSettle();
        final hipHop = find.widgetWithText(FgFilterChip, 'Hip hop');
        await _show(tester, hipHop);
        await tester.tap(hipHop);
        await tester.pumpAndSettle();
        final container = ProviderScope.containerOf(
          tester.element(find.byType(VocabularyPage)),
        );
        expect(container.read(vocabularyResultsProvider).map((e) => e.id), [
          'bounce',
          'rock',
        ]);
        expect(
          find.text(LocaleKeys.vocabularyIndex.tr(args: ['2'])),
          findsOneWidget,
        );
        final about = find.text(LocaleKeys.detailsLearnMore.tr());
        await _show(tester, about);
        await tester.tap(about);
        await tester.pumpAndSettle();
        expect(find.text(LocaleKeys.vocabularyBrowseHelp.tr()), findsOneWidget);
        expect(find.text(LocaleKeys.photoAboutBody.tr()), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Practice setup and reflection remain usable at $width and 2x text',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final block = const VocabularyRepository().practiceFor(
          const VocabularyRepository().byId('breath')!,
        );
        final page = PracticePlayerPage(block: block);
        await _pumpFeature(tester, page, textScale: 2);
        _expectDarkScreen(tester, page);
        final cue = find.text(block.cues.first);
        await _show(tester, cue);
        expect(cue, findsOneWidget);
        final safety = find.text(LocaleKeys.compactPracticeSafety.tr());
        await _show(tester, safety);
        expect(safety, findsOneWidget);
        final setup = find.text(LocaleKeys.playerSetup.tr());
        await _show(tester, setup);
        await tester.tap(setup);
        await tester.pumpAndSettle();
        final mute = find.widgetWithText(
          SwitchListTile,
          LocaleKeys.playerMute.tr(),
        );
        await _show(tester, mute);
        await tester.tap(mute);
        await tester.pumpAndSettle();
        expect(tester.widget<SwitchListTile>(mute).value, isTrue);
        final phraseStart = find.byType(DropdownButton<int>).first;
        await _show(tester, phraseStart);
        await tester.tap(phraseStart);
        await tester.pumpAndSettle();
        final fromTwo = find
            .text(LocaleKeys.playerFromCount.tr(args: ['2']))
            .last;
        expect(
          Theme.of(tester.element(fromTwo)).colorScheme.surface
              .computeLuminance(),
          lessThan(0.1),
        );
        await tester.tap(fromTwo);
        await tester.pumpAndSettle();
        expect(tester.widget<DropdownButton<int>>(phraseStart).value, 2);
        final independent = find.widgetWithText(
          SwitchListTile,
          LocaleKeys.playerIndependent.tr(),
        );
        await _show(tester, independent);
        await tester.tap(independent);
        await tester.pumpAndSettle();
        // Review expanded controls under the immersive builder, not the light host.
        _expectDarkScreen(tester, page);
        await _show(tester, setup, delta: -250);
        await tester.tap(setup);
        await tester.pumpAndSettle();
        final reflection = find.text(LocaleKeys.playerReflection.tr());
        await _show(tester, reflection);
        await tester.tap(reflection);
        await tester.pumpAndSettle();
        final notes = find.byType(TextField);
        await _show(tester, notes);
        await tester.enterText(notes, 'Keep a comfortable range.');
        await _show(tester, reflection, delta: -250);
        await tester.tap(reflection);
        await tester.pumpAndSettle();
        await tester.tap(reflection);
        await tester.pumpAndSettle();
        expect(
          tester.widget<TextField>(notes).controller!.text,
          'Keep a comfortable range.',
        );
        final adaptation = find.text(LocaleKeys.detailsAdaptations.tr());
        await _show(tester, adaptation);
        await tester.tap(adaptation);
        await tester.pumpAndSettle();
        expect(find.text(block.adaptation), findsOneWidget);
        final start = find.widgetWithText(
          FgButton,
          LocaleKeys.playerStart.tr(),
        );
        await _show(tester, start, delta: -250);
        await tester.tap(start);
        await tester.pump();
        expect(
          tester
              .widget<FgButton>(
                find.widgetWithText(FgButton, LocaleKeys.playerPause.tr()),
              )
              .isLoading,
          isFalse,
        );
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.inactive,
        );
        await tester.pump();
        expect(
          find.widgetWithText(FgButton, LocaleKeys.playerStart.tr()),
          findsOneWidget,
        );
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        expect(find.byType(FgPhoto), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Movement reference retains full guidance and locks at $width',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final entry = const VocabularyRepository().byId('bounce')!;
        final page = VocabularyEntryPage(entry: entry, onBack: () {});
        await _pumpFeature(tester, page, textScale: 2);
        _expectDarkScreen(tester, page);
        expect(find.text(entry.definition), findsOneWidget);
        final easier = find.widgetWithText(
          FgButton,
          LocaleKeys.vocabularyStartEasier.tr(),
        );
        await _show(tester, easier);
        expect(tester.widget<FgButton>(easier).isEnabled, isFalse);
        final technique = find.text(LocaleKeys.detailsMovement.tr());
        await _show(tester, technique);
        await tester.tap(technique);
        await tester.pumpAndSettle();
        for (final text in [
          entry.context,
          entry.commonMistake,
          entry.practice,
          entry.easierPractice,
          entry.harderPractice,
        ]) {
          await _show(tester, find.text(text));
          expect(find.text(text), findsOneWidget);
        }
        _expectDarkScreen(tester, page);
        final progress = find.text(LocaleKeys.detailsProgress.tr());
        await _show(tester, progress);
        await tester.tap(progress);
        await tester.pumpAndSettle();
        expect(
          find.text(LocaleKeys.programmesCompletionNotMastery.tr()),
          findsOneWidget,
        );
        expect(find.text(LocaleKeys.vocabularyNoPractice.tr()), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Vocabulary card opens its real reference and available practice starts paused',
    (tester) async {
      const page = VocabularyPage();
      final router = GoRouter(
        initialLocation: Routes.vocabulary,
        routes: [
          GoRoute(
            path: Routes.vocabulary,
            builder: (_, _) => page,
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => VocabularyEntryPage(
                  entry: const VocabularyRepository().byId(
                    state.pathParameters['id']!,
                  )!,
                  onBack: () => context.pop(),
                ),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await _pumpFeature(tester, page, router: router);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(VocabularyPage)),
      );
      await tester.runAsync(() async {
        final learning = container.read(learnViewModelProvider.notifier);
        await learning.completeLesson('common-ready-body-space-signals');
        await learning.completeLesson('common-ready-body-body-map');
      });
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'breath');
      await tester.pumpAndSettle();
      final card = find.byKey(const ValueKey('vocabulary-breath'));
      await _show(tester, card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.byType(VocabularyEntryPage), findsOneWidget);
      final start = find.widgetWithText(
        FgButton,
        LocaleKeys.vocabularyStartEasier.tr(),
      );
      await _show(tester, start);
      expect(tester.widget<FgButton>(start).isEnabled, isTrue);
      await tester.tap(start);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<PracticePlayerPage>(find.byType(PracticePlayerPage))
            .block
            .vocabularyId,
        'breath',
      );
      expect(
        find.widgetWithText(FgButton, LocaleKeys.playerStart.tr()),
        findsOneWidget,
      );
      expect(
        tester
            .widget<FgButton>(
              find.widgetWithText(FgButton, LocaleKeys.playerSave.tr()),
            )
            .isEnabled,
        isFalse,
      );
    },
  );

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

  for (final width in [320.0, 1040.0]) {
    testWidgets(
      'Home omits duplicate shortcuts and development disclosures at $width and 2x text',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        const page = HomePage();
        await _pumpFeature(tester, page, textScale: 2);
        await _show(tester, find.byKey(const ValueKey('home-content-end')));
        for (final label in [
          LocaleKeys.exploreTitle,
          LocaleKeys.forgeProgrammes,
          LocaleKeys.forgeAssessments,
          LocaleKeys.forgeLogbook,
          LocaleKeys.motionLabOpen,
          LocaleKeys.photoAboutTitle,
          LocaleKeys.photoAboutBody,
          LocaleKeys.detailsLearnMore,
        ]) {
          expect(find.text(label.tr(), skipOffstage: false), findsNothing);
        }
        expect(find.byType(FgDetails, skipOffstage: false), findsNothing);
        expect(find.byType(MotionLabPage, skipOffstage: false), findsNothing);
        expect(find.byType(FgProgressSection), findsOneWidget);
        for (final photo in tester.widgetList<FgPhoto>(
          find.byType(FgPhoto, skipOffstage: false),
        )) {
          expect(photo.image, isA<AssetImage>());
        }
        _expectDarkScreen(tester, page);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('PracticePage photo disclosure reflows at $width and 2x text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const page = PracticePage();
      await _pumpFeature(tester, page, textScale: 2);
      _expectDarkScreen(tester, page);
      expect(find.byType(FgPhoto), findsWidgets);
      for (final photo in tester.widgetList<FgPhoto>(find.byType(FgPhoto))) {
        expect(photo.image, isA<AssetImage>());
      }
      final about = find.text(LocaleKeys.photoAboutTitle.tr());
      await _show(tester, about);
      await tester.tap(about);
      await tester.pumpAndSettle();
      final explanation = find.text(LocaleKeys.photoAboutBody.tr());
      await tester.ensureVisible(explanation);
      await tester.pumpAndSettle();
      expect(explanation.hitTestable(), findsOneWidget);
      _expectDarkScreen(tester, page);
    });
  }

  for (final width in [320.0, 1040.0]) {
    testWidgets(
      'Home keeps only the first continue card with multiple active modules at $width',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final module = allModules.first;
        final lesson = module.lessons.first;
        final otherLesson = allModules[1].lessons.first;
        const home = HomePage();
        final router = GoRouter(
          initialLocation: Routes.home,
          routes: [
            GoRoute(path: Routes.home, builder: (_, _) => home),
            GoRoute(
              path: LessonDestination(module.id, lesson.id).location,
              builder: (context, _) => LessonPlayerScreen(
                lessonId: lesson.id,
                onBack: () => context.pop(),
              ),
            ),
          ],
        );
        addTearDown(router.dispose);
        await _pumpFeature(
          tester,
          home,
          router: router,
          textScale: 2,
          initialPreferences: _lessonPreferences([
            LessonProgress(
              lessonId: lesson.id,
              status: LessonStatus.inProgress,
            ),
            LessonProgress(
              lessonId: otherLesson.id,
              status: LessonStatus.inProgress,
            ),
          ]),
          beforePump: (container) async {
            expect(
              container.read(learnViewModelProvider).value!.inProgressModules,
              hasLength(2),
            );
          },
        );
        final continueLesson = find.widgetWithText(
          FgButton,
          LocaleKeys.continueLesson.tr(),
        );
        // Lay out the slivers beyond the large-text hero before inspecting them.
        await _show(tester, continueLesson);
        await _show(tester, find.byKey(const ValueKey('home-content-end')));
        expect(
          find.text(
            LocaleKeys.continueTraining.tr().toUpperCase(),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
        expect(find.byType(FgRoundPanel, skipOffstage: false), findsOneWidget);
        expect(find.byType(FgPhotoTile, skipOffstage: false), findsNothing);
        expect(
          find.text(
            LocaleKeys.photoDiscoverHeading.tr().toUpperCase(),
            skipOffstage: false,
          ),
          findsNothing,
        );
        expect(find.text(otherLesson.title, skipOffstage: false), findsNothing);
        await _show(tester, continueLesson, delta: -250);
        _expectDarkScreen(tester, home);
        await tester.runAsync(() => tester.tap(continueLesson));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<LessonPlayerScreen>(find.byType(LessonPlayerScreen))
              .lessonId,
          lesson.id,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Home practice and progress retain real routes and offline hero',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const home = HomePage();
      final router = GoRouter(
        initialLocation: Routes.home,
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => home),
          GoRoute(
            path: Routes.practice,
            builder: (_, _) => const PracticePage(),
          ),
          GoRoute(path: Routes.method, builder: (_, _) => const MethodPage()),
        ],
      );
      addTearDown(router.dispose);
      await _pumpFeature(tester, home, router: router);
      expect(
        tester.widget<FgDanceHero>(find.byType(FgDanceHero)).image,
        const AssetImage(Assets.cypherDancer),
      );
      final practice = find.widgetWithText(
        FgButton,
        LocaleKeys.forgeTodayPractice.tr(),
      );
      await tester.ensureVisible(practice);
      await tester.pumpAndSettle();
      await tester.tap(practice);
      await tester.pumpAndSettle();
      expect(find.byType(PracticePage), findsOneWidget);
      router.go(Routes.home);
      await tester.pumpAndSettle();
      final progress = find.descendant(
        of: find.byType(FgProgressSection),
        matching: find.byType(FgCard),
      );
      await _show(tester, progress);
      await tester.tap(progress);
      await tester.pumpAndSettle();
      expect(find.byType(MethodPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'workout photo hero opens the consolidated session at first round paused',
    (tester) async {
      await _pumpFeature(tester, const PracticePage());
      final start = find.byKey(const ValueKey('practice-hero-start'));
      await tester.ensureVisible(start);
      await tester.pumpAndSettle();
      await tester.tap(start);
      await tester.pumpAndSettle();
      final player = tester.widget<PracticePlayerPage>(
        find.byType(PracticePlayerPage),
      );
      final plan = buildPracticePlan(
        date: DateTime(2026, 9, 7),
        progress: MethodProgress(),
        minutes: 20,
        gentle: false,
        includeConditioning: false,
      );
      expect(find.byType(WorkoutSessionPage), findsOneWidget);
      expect(player.session!.plan.dateKey, plan.dateKey);
      expect(player.session!.rounds.length, plan.blocks.length);
      expect(player.block.id, plan.blocks.first.id);
      expect(
        find.widgetWithText(FgButton, LocaleKeys.playerStart.tr()),
        findsOneWidget,
      );
      expect(find.text(LocaleKeys.compactReady.tr()), findsOneWidget);
      expect(find.byType(FgPhoto), findsNothing);
      _expectDarkScreen(tester, player);
    },
  );

  testWidgets('Home poster and progress reflow at large text', (tester) async {
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
    await _show(tester, find.byKey(const ValueKey('home-content-end')));
    expect(find.byType(FgProgressSection), findsOneWidget);
    expect(find.byType(FgDetails, skipOffstage: false), findsNothing);
    _expectDarkScreen(tester, page);
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
    expect(find.text(ForgeCategory.rhythm.label.toUpperCase()), findsOneWidget);
    await tester.tap(find.text(LocaleKeys.detailsAboutMethod.tr()));
    await tester.pumpAndSettle();
    expect(find.text(LocaleKeys.methodCurrentHelp.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.methodSupportHelp.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.forgeCriteriaProvisional.tr()), findsOneWidget);
    await tester.tap(find.text(LocaleKeys.detailsAboutMethod.tr()));
    await tester.pumpAndSettle();
    await _show(tester, find.text(ForgeCategory.rhythm.label.toUpperCase()));
    await tester.tap(find.text(ForgeCategory.rhythm.label.toUpperCase()));
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
        find.textContaining(
          LocaleKeys.dailyPracticePrescription.tr(args: ['White', '20']),
        ),
        findsOneWidget,
      );
      final practice = find.byKey(const ValueKey('practice-hero-start'));
      expect(practice.hitTestable(), findsOneWidget);
      expect(
        find.text(LocaleKeys.compactSafety.tr()).hitTestable(),
        findsOneWidget,
      );
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
      await tester.ensureVisible(practice);
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
    final practice = find.byKey(const ValueKey('practice-hero-start'));
    await tester.scrollUntilVisible(practice, -500);
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
