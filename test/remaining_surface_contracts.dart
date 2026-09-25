part of 'feature_surface_contract_test.dart';

final _remainingImmersiveScreens = <String, Widget Function()>{
  'Circuit overview': () => const TrainingSessionPage(),
  'Circuit active': () => const TrainingSessionPage(startImmediately: true),
  'Root evidence viewer missing recording': () =>
      const EvidenceViewer(evidenceId: 'missing'),
};

class _ContractMediaRepository implements MediaRepository {
  final items = <LocalMedia>[];
  Completer<LocalMedia?>? loading;
  Object? importError;
  bool failBytes = false;
  @override
  Future<LocalMedia?> get(String id) async => loading == null
      ? items.where((item) => item.id == id).firstOrNull
      : loading!.future;
  @override
  Future<List<LocalMedia>> getAll() async => items;
  @override
  Future<Uint8List> readBytes(String id) async {
    if (failBytes) throw StateError('unreadable');
    return Uint8List(0); // Passed only to the fake transport, never a decoder.
  }

  @override
  Future<LocalMedia?> pickAndImportVideo() async {
    if (importError != null) throw importError!;
    return null;
  }

  @override
  Future<void> delete(String id) async =>
      items.removeWhere((item) => item.id == id);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

LocalMedia _localItem() => LocalMedia(
  id: 'local',
  title: 'Private practice take',
  mimeType: 'video/mp4',
  importedAt: DateTime(2026, 9, 7),
  byteLength: 1,
);

class _ContractPlayback implements LocalVideoPlayback {
  final playingEvents = StreamController<bool>.broadcast();
  final durationEvents = StreamController<Duration>.broadcast();
  final positionEvents = StreamController<Duration>.broadcast();
  final errorEvents = StreamController<String>.broadcast();
  int plays = 0;
  int pauses = 0;
  bool disposed = false;
  double rate = 1;
  Duration? sought;
  @override
  Stream<String> get errors => errorEvents.stream;
  @override
  Stream<Duration> get duration => durationEvents.stream;
  @override
  Stream<Duration> get position => positionEvents.stream;
  @override
  Stream<bool> get playing => playingEvents.stream;
  @override
  Stream<bool> get completed => const Stream.empty();
  @override
  Widget buildVideo() =>
      const SizedBox.expand(key: Key('fake-video-transport'));
  @override
  Future<void> open(Uint8List bytes, String mimeType) async {
    durationEvents.add(const Duration(seconds: 10));
  }

  @override
  Future<void> play() async {
    plays++;
    playingEvents.add(true);
  }

  @override
  Future<void> pause() async {
    pauses++;
    playingEvents.add(false);
  }

  @override
  Future<void> seek(Duration position) async {
    sought = position;
  }

  @override
  Future<void> setRate(double value) async {
    rate = value;
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    await Future.wait([
      playingEvents.close(),
      durationEvents.close(),
      positionEvents.close(),
      errorEvents.close(),
    ]);
  }
}

class _ContractSessions extends SessionRepository {
  Completer<void>? saving;
  Future<List<WorkoutSession>>? loading;
  bool fail = false;
  int writes = 0;
  final stored = <String, WorkoutSession>{};
  @override
  Future<List<WorkoutSession>> getAll() =>
      loading ?? Future.value(stored.values.toList());
  @override
  Future<({WorkoutSession session, bool created})> completeOnce(
    WorkoutSession session,
  ) async {
    writes++;
    await saving?.future;
    if (fail) throw StateError('disk full');
    final existing = stored[session.docKey];
    stored[session.docKey] = existing ?? session;
    return (session: existing ?? session, created: existing == null);
  }
}

Future<void> _finishCircuit(WidgetTester tester) async {
  for (final _ in wodFor(DateTime.now()).exercises) {
    final skip = find.widgetWithText(FgButton, LocaleKeys.skip.tr());
    await _show(tester, skip);
    await _tapStorage(tester, skip);
    await tester.pumpAndSettle();
  }
}

void _remainingSurfaceContracts() {
  _shellSurfaceContracts();
  _pendingCallerContracts();
  for (final entry in {
    'size': LocaleKeys.mediaSizeError,
    'quota': LocaleKeys.mediaQuotaError,
    'unsupported': LocaleKeys.mediaUnsupported,
    'storage': LocaleKeys.mediaStorageError,
  }.entries) {
    testWidgets(
      'Media picker ${entry.key} error keeps local controls and privacy available',
      (tester) async {
        final repository = _ContractMediaRepository()
          ..importError = MediaImportException(entry.key);
        final page = FgImmersiveScaffold(
          bodyBuilder: (_) =>
              ListView(children: [EvidencePicker(onChanged: (_) {})]),
        );
        await _pumpFeature(tester, page, mediaRepository: repository);
        await _tapStorage(
          tester,
          find.widgetWithText(FgButton, LocaleKeys.mediaImport.tr()),
        );
        await tester.pumpAndSettle();
        expect(find.text(entry.value.tr()), findsOneWidget);
        await tester.tap(find.text(LocaleKeys.detailsPrivacy.tr()));
        await tester.pumpAndSettle();
        expect(find.text(LocaleKeys.mediaPrivacy.tr()), findsOneWidget);
        _expectDarkScreen(tester, page);
      },
    );
  }
  testWidgets(
    'Native initialization failure is a readable viewer failure, not an observer leak',
    (tester) async {
      final repository = _ContractMediaRepository()..items.add(_localItem());
      await _pumpFeature(
        tester,
        const EvidenceViewer(evidenceId: 'local'),
        mediaRepository: repository,
        playbackFactory: () => throw StateError('native decoder not available'),
      );
      expect(find.text(LocaleKeys.mediaUnavailable.tr()), findsOneWidget);
      _expectTopRouteDark(tester);
      await tester.pumpWidget(const SizedBox.shrink());
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Practice history opens actual root evidence viewer', (
    tester,
  ) async {
    await _pumpFeature(
      tester,
      const PracticeLogPage(),
      records: [
        _historyRecord('latest').withReflection(
          notes: 'Review this recording',
          difficulty: 4,
          evidenceId: 'missing',
        ),
      ],
    );
    expect(find.text(LocaleKeys.practiceViewEvidence.tr()), findsNothing);
    await _openDetails(
      tester,
      find.byKey(const ValueKey('practice-record-latest')),
    );
    final evidence = find.widgetWithText(
      FgButton,
      LocaleKeys.practiceViewEvidence.tr(),
    );
    await _show(tester, evidence);
    await _tapStorage(tester, evidence);
    await tester.pumpAndSettle();
    expect(find.byType(EvidenceViewer), findsOneWidget);
    expect(find.text(LocaleKeys.mediaUnavailable.tr()), findsOneWidget);
    _expectTopRouteDark(tester);
  });

  testWidgets(
    'Leave confirmation clears stale locked skip and Cancel keeps paused exercise',
    (tester) async {
      const page = TrainingSessionPage(startImmediately: true);
      await _pumpFeature(tester, page);
      final first = wodFor(DateTime.now()).exercises.first;
      final timer = find.byType(FgTimerControl);
      await _show(tester, timer);
      await tester.tap(timer);
      await tester.pump(const Duration(seconds: 2));
      final seconds = tester.widget<FgTimerControl>(timer).remaining;
      await tester.tap(
        find.bySemanticsLabel(LocaleKeys.nextLockedSemantic.tr()),
      );
      await tester.pump(const Duration(milliseconds: 300));
      final staleSkip = tester
          .widget<SnackBarAction>(find.byType(SnackBarAction))
          .onPressed;
      final back = find.byType(BackButton).first;
      await tester.ensureVisible(back);
      await tester.pump();
      await tester.tap(back);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(SnackBarAction), findsNothing);
      staleSkip();
      await tester.pump();
      await tester.tap(
        find.widgetWithText(FgButton, LocaleKeys.practiceCancel.tr()),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      expect(find.text(first.name), findsOneWidget);
      expect(tester.widget<FgTimerControl>(timer).remaining, seconds);
      expect(tester.widget<FgTimerControl>(timer).running, false);
    },
  );
  testWidgets(
    'Circuit saving blocks back and duplicate finish until durable result',
    (tester) async {
      final repository = _ContractSessions()..saving = Completer<void>();
      var closes = 0;
      final page = TrainingSessionPage(
        startImmediately: true,
        onClose: () => closes++,
      );
      await _pumpFeature(tester, page, sessionRepository: repository);
      for (final _ in wodFor(DateTime.now()).exercises) {
        final skip = find.widgetWithText(FgButton, LocaleKeys.skip.tr());
        await _show(tester, skip);
        await _tapStorage(tester, skip);
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(find.text(LocaleKeys.workoutSaving.tr()), findsOneWidget);
      expect(repository.writes, 1);
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(closes, 0);
      expect(find.byType(AlertDialog), findsNothing);
      expect(
        tester.widget<FgStepNavigation>(find.byType(FgStepNavigation)).onNext,
        isNull,
      );
      await tester.runAsync(() async {
        repository.saving!.complete();
        await Future<void>.delayed(const Duration(milliseconds: 30));
      });
      await tester.pumpAndSettle();
      expect(repository.stored, hasLength(1));
      expect(
        find.text(
          LocaleKeys.youEarnedXp.tr(args: ['${wodFor(DateTime.now()).xp}']),
        ),
        findsOneWidget,
      );
    },
  );
  for (final width in [320.0, 1040.0]) {
    for (final entry in _remainingImmersiveScreens.entries) {
      testWidgets('${entry.key} at $width / 2x', (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final page = entry.value();
        await _pumpFeature(tester, page, textScale: 2);
        _expectDarkScreen(tester, page);
        if (page is EvidenceViewer) {
          await _show(tester, find.text(LocaleKeys.compactVideoControls.tr()));
          await tester.tap(find.text(LocaleKeys.compactVideoControls.tr()));
          await tester.pumpAndSettle();
          await _show(
            tester,
            find.text(LocaleKeys.mediaRecordedPerspective.tr()),
          );
          _expectDarkScreen(tester, page);
        }
      });
    }
    testWidgets('Circuit summary/retry and cancel at $width / 2x', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repository = _ContractSessions()..fail = true;
      var closes = 0;
      final page = TrainingSessionPage(
        startImmediately: true,
        onClose: () => closes++,
      );
      await _pumpFeature(
        tester,
        page,
        textScale: 2,
        sessionRepository: repository,
      );
      final header = tester.widget<AppHeader>(find.byType(AppHeader).first);
      header.onBack!();
      await tester.pumpAndSettle();
      _expectDarkModal(tester, find.byType(AlertDialog));
      expect(find.text(LocaleKeys.workoutLeaveBody.tr()), findsOneWidget);
      await tester.tap(
        find.widgetWithText(FgButton, LocaleKeys.practiceCancel.tr()),
      );
      await tester.pumpAndSettle();
      expect(closes, 0);
      await _finishCircuit(tester);
      expect(find.text(LocaleKeys.workoutSaveFailed.tr()), findsOneWidget);
      expect(
        find.text(
          LocaleKeys.youEarnedXp.tr(args: ['${wodFor(DateTime.now()).xp}']),
        ),
        findsNothing,
      );
      expect(repository.writes, 1);
      repository.fail = false;
      await _show(
        tester,
        find.widgetWithText(FgButton, LocaleKeys.practiceRetry.tr()),
      );
      await _tapStorage(
        tester,
        find.widgetWithText(FgButton, LocaleKeys.practiceRetry.tr()),
      );
      await tester.pumpAndSettle();
      expect(repository.stored, hasLength(1));
      expect(repository.writes, 2);
      _expectDarkScreen(tester, page);
      await tester.tap(find.bySemanticsLabel(LocaleKeys.finish.tr()));
      await tester.pumpAndSettle();
      expect(closes, 1);
    });
    testWidgets(
      'Media library selection, root view and delete at $width / 2x',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final repository = _ContractMediaRepository()
          ..items.add(_localItem())
          ..failBytes = true;
        String? selected;
        final page = FgImmersiveScaffold(
          bodyBuilder: (_) => FgReadingBody(
            child: StatefulBuilder(
              builder: (context, setState) => ListView(
                padding: AppSpacing.allLG,
                children: [
                  EvidencePicker(
                    value: selected,
                    onChanged: (value) => setState(() => selected = value),
                  ),
                ],
              ),
            ),
          ),
        );
        await _pumpFeature(
          tester,
          page,
          mediaRepository: repository,
          textScale: 2,
        );
        await _tapStorage(
          tester,
          find.widgetWithText(FgButton, LocaleKeys.mediaLibrary.tr()),
        );
        await tester.pump(const Duration(milliseconds: 300));
        _expectDarkModal(tester, find.byType(SimpleDialog));
        await _tapStorage(tester, find.text('Private practice take'));
        await tester.pumpAndSettle();
        expect(selected, 'local');
        await _show(
          tester,
          find.widgetWithText(FgButton, LocaleKeys.mediaView.tr()),
        );
        await _tapStorage(
          tester,
          find.widgetWithText(FgButton, LocaleKeys.mediaView.tr()),
        );
        await tester.pumpAndSettle();
        expect(find.byType(EvidenceViewer), findsOneWidget);
        expect(find.text(LocaleKeys.mediaUnavailable.tr()), findsOneWidget);
        _expectTopRouteDark(tester);
        Navigator.of(tester.element(find.byType(EvidenceViewer))).pop();
        await tester.pumpAndSettle();
        final delete = find.widgetWithText(
          FgButton,
          LocaleKeys.mediaDelete.tr(),
        );
        await _show(tester, delete);
        await tester.tap(delete);
        await tester.pumpAndSettle();
        _expectDarkModal(tester, find.byType(AlertDialog));
        expect(find.text(LocaleKeys.mediaDeleteConfirm.tr()), findsOneWidget);
        await tester.tap(
          find.widgetWithText(FgButton, LocaleKeys.mediaCancel.tr()),
        );
        await tester.pumpAndSettle();
        expect(repository.items, hasLength(1));
        await tester.tap(delete);
        await tester.pumpAndSettle();
        await _tapStorage(
          tester,
          find.widgetWithText(FgButton, LocaleKeys.mediaDelete.tr()).last,
        );
        await tester.pumpAndSettle();
        expect(repository.items, isEmpty);
        expect(selected, isNull);
        await _tapStorage(
          tester,
          find.widgetWithText(FgButton, LocaleKeys.mediaLibrary.tr()),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text(LocaleKeys.mediaLibraryEmpty.tr()), findsOneWidget);
      },
    );
  }
  for (final width in [320.0, 1040.0]) {
    testWidgets(
      'Video controls transport and expanded failure at $width / 2x',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final repository = _ContractMediaRepository()..items.add(_localItem());
        final playback = _ContractPlayback();
        var creates = 0;
        await _pumpFeature(
          tester,
          const EvidenceViewer(evidenceId: 'local'),
          textScale: 2,
          mediaRepository: repository,
          playbackFactory: () {
            creates++;
            return playback;
          },
        );
        expect(creates, 1);
        expect(playback.plays, 0);
        await _show(
          tester,
          find.widgetWithText(FgButton, LocaleKeys.playerStart.tr()),
        );
        await tester.tap(
          find.widgetWithText(FgButton, LocaleKeys.playerStart.tr()),
        );
        await tester.pumpAndSettle();
        expect(playback.plays, 1);
        await tester.tap(find.text(LocaleKeys.compactVideoControls.tr()));
        await tester.pumpAndSettle();
        await _show(tester, find.text(LocaleKeys.mediaMirror.tr()));
        await tester.tap(find.text(LocaleKeys.mediaMirror.tr()));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<SwitchListTile>(find.byType(SwitchListTile).first)
              .value,
          true,
        );
        final sliders = tester
            .widgetList<FgSlider>(find.byType(FgSlider))
            .toList();
        sliders[0].onChanged!(0.5);
        sliders[1].onChanged!(3);
        await tester.pump();
        expect(playback.rate, 0.5);
        expect(playback.sought, const Duration(seconds: 3));
        playback.positionEvents.add(const Duration(seconds: 10));
        await tester.pump();
        expect(playback.sought, Duration.zero);
        _expectTopRouteDark(tester);
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();
        expect(playback.pauses, 1);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        playback.errorEvents.add('decoder failure');
        await tester.pumpAndSettle();
        await _show(
          tester,
          find.text(LocaleKeys.mediaUnsupported.tr()),
          delta: -250,
        );
        _expectTopRouteDark(tester);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(playback.disposed, true);
      },
    );
  }
  testWidgets('Missing and loading evidence never constructs a native player', (
    tester,
  ) async {
    final repository = _ContractMediaRepository()
      ..loading = Completer<LocalMedia?>();
    var creates = 0;
    await _pumpFeature(
      tester,
      const EvidenceViewer(evidenceId: 'missing'),
      mediaRepository: repository,
      playbackFactory: () {
        creates++;
        return _ContractPlayback();
      },
    );
    expect(find.text(LocaleKeys.mediaLoading.tr()), findsOneWidget);
    expect(creates, 0);
    await tester.runAsync(() async {
      repository.loading!.complete(null);
    });
    await tester.pumpAndSettle();
    expect(find.text(LocaleKeys.mediaUnavailable.tr()), findsOneWidget);
    expect(creates, 0);
  });
  testWidgets('Circuit loading and failed initial load remain immersive', (
    tester,
  ) async {
    final loading = Completer<List<WorkoutSession>>();
    final repository = _ContractSessions()..loading = loading.future;
    const page = TrainingSessionPage();
    await _pumpFeature(
      tester,
      page,
      sessionRepository: repository,
      waitForWorkout: false,
      waitForLearning: false,
      settle: false,
    );
    _expectDarkScreen(tester, page);
    expect(find.byType(FgSpinner), findsOneWidget);
    await tester.runAsync(() async {
      loading.completeError(StateError('unavailable'));
    });
    await tester.pumpAndSettle();
    _expectDarkScreen(tester, page);
    expect(find.text(LocaleKeys.unexpectedErrorOccurred.tr()), findsOneWidget);
    repository.loading = null;
    await _tapStorage(
      tester,
      find.widgetWithText(FgButton, LocaleKeys.practiceRetry.tr()),
    );
    await tester.pumpAndSettle();
    expect(find.text(wodFor(DateTime.now()).title), findsOneWidget);
  });
}

void _expectDarkModal(WidgetTester tester, Finder finder) {
  final context = tester.element(finder);
  final scheme = Theme.of(context).colorScheme;
  expect(scheme.surface.computeLuminance(), lessThan(0.1));
  expect(
    _contrast(scheme.onSurface, scheme.surface),
    greaterThanOrEqualTo(4.5),
  );
  _expectReadableText(tester, finder, scheme.surface);
  expect(tester.takeException(), isNull);
}

class _GuardedPracticeRepository extends PracticeRepository {
  @override
  Future<List<PracticeRecord>> getAll() async => [];
  final submitted = <PracticeRecord>[];
  Completer<void>? hold;
  bool fail = true;
  @override
  Future<void> record(PracticeRecord record) async {
    submitted.add(record);
    await hold?.future;
    if (fail) throw StateError('write refused');
  }
}

GoRouter _contractShell(String initial, {Widget? method, Widget? vocabulary}) {
  final navigation = ShellNavigationObserver();
  return GoRouter(
    initialLocation: initial,
    routes: [
      ShellRoute(
        observers: [navigation],
        builder: (_, state, child) => MainScreen(
          location: state.uri.path,
          canChangeTab: () => navigation.canChangeTab,
          child: child,
        ),
        routes: [
          GoRoute(
            path: Routes.practice,
            builder: (_, _) => const PracticePage(),
          ),
          GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
          GoRoute(
            path: Routes.programmes,
            builder: (_, _) => const ProgrammesPage(),
          ),
          GoRoute(
            path: Routes.method,
            builder: (_, _) => method ?? const MethodPage(),
          ),
          GoRoute(
            path: Routes.workout,
            builder: (_, _) => const TrainingSessionPage(),
          ),
          GoRoute(path: Routes.explore, builder: (_, _) => const ExplorePage()),
          GoRoute(path: Routes.profile, builder: (_, _) => const ProfilePage()),
          GoRoute(
            path: Routes.vocabulary,
            builder: (_, _) => vocabulary ?? const VocabularyPage(),
          ),
        ],
      ),
    ],
  );
}

void _shellSurfaceContracts() {
  for (final width in [320.0, 390.0, 1040.0]) {
    testWidgets('Shell full labels and real tab selection at $width / 2x', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final router = _contractShell(Routes.workout);
      addTearDown(router.dispose);
      await _pumpFeature(
        tester,
        const SizedBox.shrink(),
        router: router,
        textScale: 2,
      );
      expect(
        find.text(LocaleKeys.vocabularyTitle.tr()).hitTestable(),
        findsOneWidget,
      );
      final label = find.text(LocaleKeys.vocabularyTitle.tr());
      final rich = tester.widget<RichText>(
        find.descendant(of: label, matching: find.byType(RichText)),
      );
      final painter = TextPainter(
        text: rich.text,
        textDirection: Directionality.of(tester.element(label)),
        textScaler: TextScaler.linear(2),
      )..layout();
      expect(
        tester.getSize(label).width,
        greaterThanOrEqualTo(painter.width - 0.1),
      );
      expect(
        tester.getSize(find.byType(TrainingSessionPage)).height,
        greaterThan(200),
      );
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, Routes.home);
      final selected = tester.widget<FgNavButton>(
        find.widgetWithText(FgNavButton, 'Home'),
      );
      expect(selected.isActive, true);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'Actual shell keeps consolidated workout above tabs through durable save and explicit exit',
    (tester) async {
      final repo = _GuardedPracticeRepository()..hold = Completer<void>();
      final router = _contractShell(Routes.practice);
      addTearDown(router.dispose);
      final times = <WorkoutTestStopwatch>[];
      late ProviderContainer container;
      await _pumpFeature(
        tester,
        const SizedBox.shrink(),
        router: router,
        practiceRepository: repo,
        beforePump: (value) async => container = value,
        workoutSessionFactory: (plan, save) => daily.WorkoutSession(
          plan: plan,
          save: save,
          clockFactory: (block) {
            final time = WorkoutTestStopwatch();
            times.add(time);
            return PracticeClock(bpm: block.bpm, stopwatch: time);
          },
        ),
      );
      final start = find.byKey(const ValueKey('practice-hero-start'));
      await _show(tester, start);
      await tester.tap(start);
      await tester.pumpAndSettle();
      final session = tester
          .widget<WorkoutSessionPage>(find.byType(WorkoutSessionPage))
          .session;
      final frozen = session.plan;
      await tester.runAsync(
        () => container
            .read(practicePreferencesViewModelProvider.notifier)
            .save(
              const PracticePreferences(
                minutes: 10,
                support: PracticeSupport.seated,
                gentle: true,
              ),
            ),
      );
      await tester.pumpAndSettle();
      expect(session.plan, same(frozen));
      expect(session.current.block, same(frozen.blocks.first));
      session.current.clock.start();
      times.first.advance(
        Duration(seconds: frozen.blocks.first.minutes * 60 + 12),
      );
      session.pause();
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('workout-next')));
      await tester.pump();
      expect(session.saving, true);
      expect(find.text('Home').hitTestable(), findsNothing);
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      unawaited(navigator.maybePop());
      await tester.pump();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(WorkoutSessionPage), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, Routes.practice);
      await tester.runAsync(() async {
        repo.hold!.complete();
      });
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('workout-save-error')), findsOneWidget);
      expect(session.index, 0);
      expect(find.text('Home').hitTestable(), findsNothing);
      repo.fail = false;
      repo.hold = null;
      await _tapStorage(tester, find.byKey(const ValueKey('workout-retry')));
      await tester.pumpAndSettle();
      expect(session.index, 1);
      expect(repo.submitted.length, 2);
      expect(repo.submitted.first, same(repo.submitted.last));
      expect(find.byType(WorkoutSessionPage), findsOneWidget);
      unawaited(navigator.maybePop());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('workout-confirm')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, Routes.home);
    },
  );
  testWidgets(
    'Actual shell respects imperative assessment save guard but allows read-only detail tabs',
    (tester) async {
      final repo = _RetryMethodRepository()
        ..fail = false
        ..saving = Completer<void>();
      final router = _contractShell(
        Routes.method,
        method: const MethodPage(initialCategory: ForgeCategory.rhythm),
      );
      addTearDown(router.dispose);
      await _pumpFeature(
        tester,
        const SizedBox.shrink(),
        router: router,
        methodRepository: repo,
      );
      final assessment = assessmentById('rhythm-1-v1');
      await _show(tester, find.text(assessment.title));
      await tester.tap(find.text(assessment.title));
      await tester.pumpAndSettle();
      for (final criterion in assessment.criteria) {
        final control = find.byWidgetPredicate(
          (widget) =>
              widget is FgCheckboxItem &&
              widget.semanticLabel == criterion.text,
        );
        await _show(tester, control);
        await tester.tap(control);
      }
      final confirm = find.byWidgetPredicate(
        (widget) =>
            widget is FgCheckboxItem &&
            widget.semanticLabel == LocaleKeys.methodConfirm.tr(),
      );
      await _show(tester, confirm);
      await tester.tap(confirm);
      final save = find.widgetWithText(
        FgButton,
        LocaleKeys.methodSaveAssessment.tr(),
      );
      await _show(tester, save);
      await _tapStorage(tester, save);
      await tester.pump();
      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(router.routeInformationProvider.value.uri.path, Routes.method);
      await tester.runAsync(() async {
        repo.saving!.complete();
      });
      await tester.pumpAndSettle();
      // A fresh read-only category is still an imperative route, but not a guard.
      final context = tester.element(find.byType(MethodPage).first);
      unawaited(
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) =>
                const MethodPage(initialCategory: ForgeCategory.rhythm),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, Routes.home);
    },
  );
  testWidgets('Circuit compact-height cues scroll while next stays reachable', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1040, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const page = TrainingSessionPage(startImmediately: true);
    await _pumpFeature(tester, page, textScale: 2);
    await _show(tester, find.text(LocaleKeys.workoutWrittenCues.tr()));
    expect(
      find.text(LocaleKeys.workoutWrittenCues.tr()).hitTestable(),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(LocaleKeys.nextLockedSemantic.tr()).hitTestable(),
      findsOneWidget,
    );
    _expectDarkScreen(tester, page);
  });
}

class _ContractProgrammes extends ProgrammeRepository {
  Set<String> ids = {forgeProgrammes.first.id};
  Completer<void>? hold;
  @override
  Future<Set<String>> getEnrolledIds() async => ids;
  @override
  Future<void> enrol(String id) async {
    await hold?.future;
    ids = {...ids, id};
  }
}

void _pendingCallerContracts() {
  for (final programme in [true, false]) {
    for (final width in [320.0, 1040.0]) {
      testWidgets(
        '${programme ? 'Programme' : 'Vocabulary'} pending caller guard retry/discard at $width / 2x',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final repo = _GuardedPracticeRepository();
          final initial = programme ? Routes.programmes : Routes.vocabulary;
          final router = _contractShell(
            initial,
            vocabulary: VocabularyEntryPage(
              entry: const VocabularyRepository().byId('breath')!,
              onBack: () {},
            ),
          );
          addTearDown(router.dispose);
          await _pumpFeature(
            tester,
            const SizedBox.shrink(),
            router: router,
            textScale: 2,
            practiceRepository: repo,
            programmeRepository: _ContractProgrammes(),
            beforePump: (container) async {
              final learning = container.read(learnViewModelProvider.notifier);
              await learning.completeLesson('common-ready-body-space-signals');
              await learning.completeLesson('common-ready-body-body-map');
            },
          );
          if (programme) {
            await _openProgramme(tester);
            await _openDetails(
              tester,
              find.byKey(
                ValueKey('programme-schedule-${forgeProgrammes.first.id}'),
              ),
            );
          }
          final start = find
              .widgetWithText(
                FgButton,
                (programme
                        ? LocaleKeys.programmesPracticeSession
                        : LocaleKeys.vocabularyStartEasier)
                    .tr(),
              )
              .first;
          await _show(tester, start);
          await tester.tap(start);
          await tester.pumpAndSettle();
          final player = tester.widget<PracticePlayerPage>(
            find.byType(PracticePlayerPage),
          );
          final block = player.block;
          final record = PracticeRecord(
            id: 'caller-result',
            blockId: block.id,
            title: block.title,
            lessonId: block.lessonId,
            vocabularyId: block.vocabularyId,
            workoutId: block.workoutId,
            workoutDate: block.workoutDate,
            category: block.category,
            level: block.level,
            performedAt: DateTime.utc(2026, 9, 7),
            durationSeconds: 27,
            bpm: block.bpm,
            attempts: 2,
            difficulty: 4,
          );
          await tester.runAsync(() async {
            Navigator.of(tester.element(find.byType(PracticePlayerPage)))
                .pop(record);
            await Future<void>.delayed(const Duration(milliseconds: 20));
          });
          await tester.pumpAndSettle();
          expect(find.text(LocaleKeys.practiceUnsaved.tr()), findsOneWidget);
          expect(
            find.text(LocaleKeys.programmesSaveError.tr()),
            findsOneWidget,
          );
          _expectTopRouteDark(tester);
          await tester.tap(find.text('Home'));
          await tester.pump();
          expect(router.routeInformationProvider.value.uri.path, initial);
          final discard = find.widgetWithText(
            FgButton,
            LocaleKeys.practiceDiscard.tr(),
          );
          await _show(tester, discard);
          await tester.tap(discard);
          await tester.pumpAndSettle();
          expect(
            find.text(LocaleKeys.practiceDiscardBody.tr()),
            findsOneWidget,
          );
          _expectDarkModal(tester, find.byType(AlertDialog));
          await tester.tap(
            find.widgetWithText(FgButton, LocaleKeys.practiceCancel.tr()),
          );
          await tester.pumpAndSettle();
          expect(repo.submitted, hasLength(1));
          final retry = find.widgetWithText(
            FgButton,
            LocaleKeys.practiceRetrySave.tr(),
          );
          await _show(tester, retry);
          repo.fail = false;
          repo.hold = Completer<void>();
          await _tapStorage(tester, retry);
          await tester.pump();
          await tester.tap(find.text('Home'));
          await tester.pump();
          expect(router.routeInformationProvider.value.uri.path, initial);
          await tester.runAsync(() async {
            repo.hold!.complete();
          });
          await tester.pumpAndSettle();
          expect(repo.submitted, hasLength(2));
          expect(repo.submitted[1], same(record));
          expect(repo.submitted[0], same(record));
          if (width == 320) {
            await tester.pump(const Duration(seconds: 6));
            await tester.pumpAndSettle();
            repo.fail = true;
            repo.hold = null;
            if (programme) {
              await _openDetails(
                tester,
                find.byKey(
                  ValueKey('programme-schedule-${forgeProgrammes.first.id}'),
                ),
              );
            }
            await _show(tester, start);
            await tester.tap(start);
            await tester.pumpAndSettle();
            await tester.runAsync(() async {
              Navigator.of(tester.element(find.byType(PracticePlayerPage)))
                  .pop(record);
              await Future<void>.delayed(const Duration(milliseconds: 20));
            });
            await tester.pumpAndSettle();
            await _show(
              tester,
              find.widgetWithText(FgButton, LocaleKeys.practiceDiscard.tr()),
            );
            await tester.tap(
              find.widgetWithText(FgButton, LocaleKeys.practiceDiscard.tr()),
            );
            await tester.pumpAndSettle();
            await tester.tap(
              find
                  .widgetWithText(FgButton, LocaleKeys.practiceDiscard.tr())
                  .last,
            );
            await tester.pumpAndSettle();
            expect(find.text(LocaleKeys.practiceUnsaved.tr()), findsNothing);
            expect(repo.submitted, hasLength(3));
          }
          await tester.tap(find.text('Home'));
          await tester.pumpAndSettle();
          expect(router.routeInformationProvider.value.uri.path, Routes.home);
        },
      );
    }
  }
  testWidgets('Programme busy enrolment blocks tab departure until saved', (
    tester,
  ) async {
    final repository = _ContractProgrammes()
      ..ids = {}
      ..hold = Completer<void>();
    final router = _contractShell(Routes.programmes);
    addTearDown(router.dispose);
    await _pumpFeature(
      tester,
      const SizedBox.shrink(),
      router: router,
      programmeRepository: repository,
    );
    await _openProgramme(tester);
    final start = find.widgetWithText(
      FgButton,
      LocaleKeys.programmesStart.tr(),
    );
    await _show(tester, start);
    await _tapStorage(tester, start);
    await tester.pump();
    await tester.tap(find.text('Home'));
    await tester.pump();
    expect(router.routeInformationProvider.value.uri.path, Routes.programmes);
    await tester.runAsync(() async {
      repository.hold!.complete();
    });
    await tester.pumpAndSettle();
    expect(repository.ids, contains(forgeProgrammes.first.id));
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, Routes.home);
  });
}
