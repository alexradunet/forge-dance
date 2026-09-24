part of 'feature_surface_contract_test.dart';

class _ReviewProgrammes extends ProgrammeRepository {
  Future<Set<String>>? read;
  @override
  Future<Set<String>> getEnrolledIds() => read ?? Future.value({});
}

class _ReviewMedia extends _ContractMediaRepository {
  Completer<LocalMedia?>? importing;
  Completer<void>? deleting;
  int imports = 0;
  int deletes = 0;
  @override
  Future<LocalMedia?> pickAndImportVideo() async {
    imports++;
    return importing!.future;
  }

  @override
  Future<void> delete(String id) async {
    deletes++;
    await deleting!.future;
    await super.delete(id);
  }
}

// Only the clock is overridden: UI calls the real completion/reset methods.
class _ClockedCircuit extends WorkoutViewModel {
  _ClockedCircuit(this.moment);
  DateTime moment;
  @override
  Future<bool> completeWod({DateTime? now}) =>
      super.completeWod(now: now ?? moment);
}

class _DiscardBoundarySessions extends SessionRepository {
  _DiscardBoundarySessions({required this.commitBeforeFailure});
  final bool commitBeforeFailure;
  bool fail = true;
  final submissions = <WorkoutSession>[];
  @override
  Future<({WorkoutSession session, bool created})> completeOnce(
    WorkoutSession completion,
  ) async {
    submissions.add(completion);
    if (fail) {
      if (commitBeforeFailure) await super.completeOnce(completion);
      throw StateError('completion unavailable');
    }
    return super.completeOnce(completion);
  }
}

void _circuitDiscardBoundaryContracts() {
  for (final committed in [false, true]) {
    for (final discard in [false, true]) {
      testWidgets(
        'Retained circuit overview: failed ${committed ? 'committed write' : 'pre-write'} then ${discard ? 'Discard/new session' : 'Cancel/retry'} across midnight',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(390, 844));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final today = DateTime.now();
          final beforeMidnight = DateTime(
            today.year,
            today.month,
            today.day,
            23,
            59,
            59,
          );
          final afterMidnight = beforeMidnight.add(const Duration(seconds: 2));
          final clocked = _ClockedCircuit(beforeMidnight);
          final repository = _DiscardBoundarySessions(
            commitBeforeFailure: committed,
          );
          // Same nested actual overview/session composition as the production
          // route: the overview remains mounted beneath the session.
          final router = GoRouter(
            initialLocation: Routes.workout,
            routes: [
              GoRoute(
                path: Routes.workout,
                builder: (context, _) => TrainingSessionPage(
                  onStart: () => context.push(Routes.workoutSession),
                ),
                routes: [
                  GoRoute(
                    path: 'session',
                    builder: (context, _) => TrainingSessionPage(
                      startImmediately: true,
                      onClose: () => context.pop(),
                    ),
                  ),
                ],
              ),
            ],
          );
          addTearDown(router.dispose);
          await _pumpFeature(
            tester,
            const SizedBox.shrink(),
            router: router,
            sessionRepository: repository,
            workoutViewModel: () => clocked,
          );
          final overview = find.byWidgetPredicate(
            (widget) =>
                widget is TrainingSessionPage && !widget.startImmediately,
            skipOffstage: false,
          );
          final overviewState = tester.state(overview);
          final container = ProviderScope.containerOf(tester.element(overview));
          final retained = container.read(workoutViewModelProvider.notifier);
          final wod = container.read(workoutViewModelProvider).requireValue.wod;
          Future<void> start() async {
            final start = find.bySemanticsLabel(
              LocaleKeys.startWorkoutSemantic.tr(),
            );
            await _show(tester, start, delta: -250);
            await tester.tap(start);
            await tester.pumpAndSettle();
            expect(router.canPop(), true);
            expect(
              tester
                  .widget<TrainingSessionPage>(find.byType(TrainingSessionPage))
                  .startImmediately,
              true,
            );
            expect(overview, findsOneWidget);
            expect(tester.state(overview), same(overviewState));
            expect(
              container.read(workoutViewModelProvider.notifier),
              same(retained),
            );
          }

          await start();
          await _finishCircuit(tester);
          expect(find.text(LocaleKeys.workoutSaveFailed.tr()), findsOneWidget);
          expect(repository.submissions, hasLength(1));
          final original = repository.submissions.single;
          final beforeDiscard = (await tester.runAsync(repository.getAll))!;
          expect(beforeDiscard, hasLength(committed ? 1 : 0));
          if (committed) expect(beforeDiscard.single, original);
          final back = find.byType(BackButton).first;
          await _show(tester, back, delta: -250);
          await tester.tap(back);
          await tester.pumpAndSettle();
          _expectDarkModal(tester, find.byType(AlertDialog));
          await tester.tap(
            find.widgetWithText(
              FgButton,
              (discard ? LocaleKeys.practiceDiscard : LocaleKeys.practiceCancel)
                  .tr(),
            ),
          );
          await tester.pumpAndSettle();
          final afterDecision = (await tester.runAsync(repository.getAll))!;
          expect(
            afterDecision,
            beforeDiscard,
            reason: 'Neither Cancel nor Discard deletes durable records.',
          );
          clocked.moment = afterMidnight;
          repository.fail = false;
          if (discard) {
            expect(router.canPop(), false);
            expect(overview.hitTestable(), findsOneWidget);
            await start();
            await _finishCircuit(tester);
          } else {
            expect(router.canPop(), true);
            expect(
              tester
                  .widget<TrainingSessionPage>(find.byType(TrainingSessionPage))
                  .startImmediately,
              true,
            );
            expect(
              find.text(LocaleKeys.workoutSaveFailed.tr()),
              findsOneWidget,
            );
            await _tapStorage(
              tester,
              find.widgetWithText(FgButton, LocaleKeys.practiceRetry.tr()),
            );
            await tester.pumpAndSettle();
          }
          expect(
            container.read(workoutViewModelProvider.notifier),
            same(retained),
          );
          expect(repository.submissions, hasLength(2));
          final next = repository.submissions.last;
          expect(next.workoutId, original.workoutId);
          expect(
            next.date,
            DateFormat('yyyy-MM-dd')
                .format(discard ? afterMidnight : beforeMidnight),
          );
          expect(next.docKey == original.docKey, !discard);
          final records = (await tester.runAsync(repository.getAll))!;
          final expectedCount = discard && committed ? 2 : 1;
          expect(records, hasLength(expectedCount));
          if (committed) expect(records, contains(original));
          expect(records.map((item) => item.docKey).toSet(), {
            if (committed) original.docKey,
            next.docKey,
          });
          final reward = !discard && committed
              ? LocaleKeys.alreadyCompletedToday.tr()
              : LocaleKeys.youEarnedXp.tr(args: ['${wod.xp}']);
          expect(find.text(reward), findsOneWidget);
          // A repeated completion still deduplicates. Projection derives exactly
          // one award per durable record, including a prior committed failure.
          expect(
            await tester.runAsync(
              () => retained.completeWod(now: afterMidnight),
            ),
            false,
          );
          final finalRecords = (await tester.runAsync(repository.getAll))!;
          expect(finalRecords, records);
          final profile = await tester.runAsync(
            () => container.read(profileRepositoryProvider).get(),
          );
          expect(profile!.xp, expectedCount * wod.xp);
          _expectTopRouteDark(tester);
        },
      );
    }
  }
}

void _reviewSurfaceContracts() {
  _circuitDiscardBoundaryContracts();
  testWidgets('Unknown lesson never substitutes another lesson', (
    tester,
  ) async {
    const page = LessonPlayerScreen(lessonId: 'unknown-lesson');
    await _pumpFeature(tester, page);
    expect(find.text(LocaleKeys.unexpectedErrorOccurred.tr()), findsOneWidget);
    expect(
      find.widgetWithText(FgButton, LocaleKeys.completeLesson.tr()),
      findsNothing,
    );
    _expectDarkScreen(tester, page);
  });

  for (final width in [320.0, 1040.0]) {
    for (final learning in [true, false]) {
      testWidgets(
        'Programme detail ${learning ? 'learning' : 'enrolment'} loading/error/retry at $width / 2x',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final progress = _SurfaceProgressRepository();
          final programmes = _ReviewProgrammes();
          await _pumpFeature(
            tester,
            const ProgrammesPage(),
            progressRepository: progress,
            programmeRepository: programmes,
            textScale: 2,
          );
          await _openProgramme(tester);
          final container = ProviderScope.containerOf(
            tester.element(find.byType(FgImmersiveScaffold).last),
          );
          late Completer<Map<String, LessonProgress>> progressRead;
          late Completer<Set<String>> programmeRead;
          await tester.runAsync(() async {
            if (learning) {
              progressRead = Completer<Map<String, LessonProgress>>();
              progress.nextRead = progressRead.future;
              container.invalidate(learnViewModelProvider);
            } else {
              programmeRead = Completer<Set<String>>();
              programmes.read = programmeRead.future;
              container.invalidate(programmesViewModelProvider);
            }
            await Future<void>.delayed(Duration.zero);
          });
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          expect(find.byType(FgSpinner), findsOneWidget);
          _expectTopRouteDark(tester);
          await tester.runAsync(() async {
            if (learning) {
              progressRead.completeError(StateError('storage unavailable'));
            } else {
              programmeRead.completeError(StateError('storage unavailable'));
            }
            await Future<void>.delayed(Duration.zero);
          });
          await tester.pumpAndSettle();
          final retry = find.widgetWithText(
            FgButton,
            LocaleKeys.programmesRetry.tr(),
          );
          expect(retry, findsOneWidget);
          _expectTopRouteDark(tester);
          progress.nextRead = null;
          programmes.read = null;
          await _tapStorage(tester, retry);
          await tester.pumpAndSettle();
          expect(retry, findsNothing);
          expect(find.byType(FgSpinner), findsNothing);
          _expectTopRouteDark(tester);
        },
      );
    }

    testWidgets(
      'Actual belt sheet loading/error and dismiss/recover at $width / 2x',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final repository = _RetryMethodRepository();
        await _pumpFeature(
          tester,
          const ProfilePage(),
          methodRepository: repository,
          profileRepository: _PersonalProfileRepository(),
          textScale: 2,
        );
        final container = ProviderScope.containerOf(
          tester.element(find.byType(ProfilePage)),
        );
        final belt = find.byWidgetPredicate(
          (widget) => widget is LevelItem && widget.level.id == 2,
        );
        await _show(tester, belt);
        await tester.tap(belt);
        await tester.pumpAndSettle();
        late Completer<MethodProgress> pending;
        await tester.runAsync(() async {
          pending = Completer<MethodProgress>();
          repository.nextRead = pending.future;
          unawaited(container.read(methodViewModelProvider.notifier).reload());
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        final sheet = tester.widget<LevelProgressionPage>(
          find.byType(LevelProgressionPage),
        );
        expect(
          find.descendant(
            of: find.byWidget(sheet),
            matching: find.byType(FgSpinner),
          ),
          findsOneWidget,
        );
        _expectDarkScreen(tester, sheet);
        await tester.runAsync(() async {
          pending.completeError(StateError('storage unavailable'));
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: find.byWidget(sheet),
            matching: find.text(LocaleKeys.unexpectedErrorOccurred.tr()),
          ),
          findsOneWidget,
        );
        _expectDarkScreen(tester, sheet);
        Navigator.of(tester.element(find.byWidget(sheet))).pop();
        await tester.pumpAndSettle();
        expect(find.byType(LevelProgressionPage), findsNothing);
        repository.nextRead = null;
        await _tapStorage(
          tester,
          find.widgetWithText(FgButton, LocaleKeys.practiceRetry.tr()),
        );
        await tester.pumpAndSettle();
        await _show(tester, belt);
        await tester.tap(belt);
        await tester.pumpAndSettle();
        _expectTopRouteDark(tester);
      },
    );

    testWidgets(
      'EvidencePicker metadata loading/error and held import/delete at $width / 2x',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final repository = _ReviewMedia()..items.add(_localItem());
        await tester.runAsync(() async {
          repository.loading = Completer<LocalMedia?>();
          repository.importing = Completer<LocalMedia?>();
          repository.deleting = Completer<void>();
        });
        String? selected = 'local';
        final page = FgImmersiveScaffold(
          bodyBuilder: (_) => StatefulBuilder(
            builder: (context, setState) => ListView(
              children: [
                EvidencePicker(
                  value: selected,
                  onChanged: (value) => setState(() => selected = value),
                ),
              ],
            ),
          ),
        );
        await _pumpFeature(
          tester,
          page,
          textScale: 2,
          mediaRepository: repository,
        );
        expect(find.text(LocaleKeys.mediaLoading.tr()), findsOneWidget);
        _expectDarkScreen(tester, page);
        await tester.runAsync(() async {
          repository.loading!.completeError(StateError('metadata unavailable'));
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(find.text(LocaleKeys.mediaStorageError.tr()), findsOneWidget);
        _expectDarkScreen(tester, page);
        repository.loading = null;
        await _tapStorage(
          tester,
          find.widgetWithText(FgButton, LocaleKeys.mediaImport.tr()),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        void expectBusy() {
          for (final key in [
            LocaleKeys.mediaLibrary,
            LocaleKeys.mediaView,
            LocaleKeys.mediaUnlink,
            LocaleKeys.mediaDelete,
          ]) {
            final button = tester.widget<FgButton>(
              find.widgetWithText(FgButton, key.tr()),
            );
            expect(button.isEnabled, false);
          }
          expect(
            tester
                .widget<FgButton>(
                  find.byWidgetPredicate(
                    (widget) =>
                        widget is FgButton &&
                        widget.text == LocaleKeys.mediaImport.tr(),
                  ),
                )
                .isLoading,
            true,
          );
          _expectDarkScreen(tester, page);
        }

        expectBusy();
        expect(repository.imports, 1);
        expect(selected, 'local');
        await tester.runAsync(() async {
          repository.importing!.complete(_localItem());
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(find.text(_localItem().title), findsOneWidget);
        final remove = find.widgetWithText(
          FgButton,
          LocaleKeys.mediaDelete.tr(),
        );
        await _show(tester, remove);
        await tester.tap(remove);
        await tester.pumpAndSettle();
        _expectDarkModal(tester, find.byType(AlertDialog));
        await _tapStorage(
          tester,
          find.descendant(of: find.byType(AlertDialog), matching: remove),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expectBusy();
        expect(repository.deletes, 1);
        expect(selected, 'local');
        await tester.runAsync(() async {
          repository.deleting!.complete();
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(selected, isNull);
        expect(repository.items, isEmpty);
        expect(
          find.widgetWithText(FgButton, LocaleKeys.mediaView.tr()),
          findsNothing,
        );
        expect(
          tester
              .widget<FgButton>(
                find.widgetWithText(FgButton, LocaleKeys.mediaLibrary.tr()),
              )
              .isEnabled,
          true,
        );
      },
    );

    testWidgets(
      'Offline banner stream leaves real Home usable at $width / 2x',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        const channel = MethodChannel(
          'dev.fluttercommunity.plus/connectivity_status',
        );
        final messenger = tester.binding.defaultBinaryMessenger;
        messenger.setMockMethodCallHandler(channel, (_) async => null);
        addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
        const page = OfflineContainer(child: HomePage());
        await _pumpFeature(tester, page, textScale: 2);
        Future<void> emit(String state) async {
          await messenger.handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeSuccessEnvelope([state]),
            (_) {},
          );
          await tester.pumpAndSettle();
        }

        expect(find.text(LocaleKeys.offline.tr()), findsNothing);
        await emit('none');
        expect(find.text(LocaleKeys.offline.tr()), findsOneWidget);
        final banner = find
            .ancestor(
              of: find.text(LocaleKeys.offline.tr()),
              matching: find.byType(ColoredBox),
            )
            .first;
        _expectReadableText(
          tester,
          banner,
          tester.widget<ColoredBox>(banner).color,
        );
        expect(find.bySemanticsLabel(LocaleKeys.offline.tr()), findsOneWidget);
        expect(find.byType(HomePage), findsOneWidget);
        _expectDarkScreen(
          tester,
          tester.widget<HomePage>(find.byType(HomePage)),
        );
        await emit('wifi');
        expect(find.text(LocaleKeys.offline.tr()), findsNothing);
        expect(find.byType(HomePage), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
