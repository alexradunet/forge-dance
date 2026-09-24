part of 'feature_surface_contract_test.dart';

void _workoutSessionSurfaceContracts() {
  for (final pending in [false, true]) {
    testWidgets(
      'consolidated workout readonly ${pending ? 'pending' : 'completed'} reflection/media and independent disclosure semantics',
      (tester) async {
        final repository = _ReadonlyWorkoutMediaRepository()
          ..items.add(_localItem());
        final fixture = WorkoutTestFixture(
          save: (_) async {
            if (pending) throw StateError('fixture write failure');
          },
        );
        const notes =
            'Full retained reflection with enough words to wrap at narrow widths, never editable during saved review or a pending retry.';
        fixture.session.current.notes = notes;
        fixture.session.current.evidence = 'local';
        fixture.completeTarget();
        await fixture.session.next('guided');
        if (!pending) fixture.session.previous();
        final page = WorkoutSessionPage(session: fixture.session);
        await _pumpFeature(tester, page, mediaRepository: repository);
        final semantics = tester.ensureSemantics();
        final disclosure = find.text(LocaleKeys.workoutNavigationDetails.tr());
        final data = tester.getSemantics(disclosure).getSemanticsData();
        expect(data.label, LocaleKeys.workoutNavigationDetails.tr());
        expect(data.hasAction(SemanticsAction.tap), true);
        expect(
          data.hint,
          contains(
            MaterialLocalizations.of(tester.element(disclosure)).expandedHint,
          ),
        );
        expect(data.label, isNot(contains('Round 1')));
        final setup = find.text(LocaleKeys.playerSetup.tr());
        await _show(tester, setup);
        await tester.tap(setup);
        await tester.pumpAndSettle();
        final switches = find.descendant(
          of: find.byKey(const ValueKey('player-setup')),
          matching: find.byType(SwitchListTile),
        );
        for (final tile in tester.widgetList<SwitchListTile>(switches)) {
          expect(tile.onChanged, isNull);
        }
        final sliders = find.descendant(
          of: find.byKey(const ValueKey('player-setup')),
          matching: find.byType(FgSlider),
        );
        expect(tester.widget<FgSlider>(sliders).onChanged, isNull);
        final reflection = find.text(LocaleKeys.playerReflection.tr());
        await _show(tester, reflection);
        await tester.tap(reflection);
        await tester.pumpAndSettle();
        final retained = find.text(notes);
        await _show(tester, retained);
        expect(
          tester.getSemantics(retained).getSemanticsData().label,
          contains(notes),
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('player-reflection')),
            matching: find.byType(TextField),
          ),
          findsNothing,
        );
        final media = find.widgetWithText(
          FgButton,
          LocaleKeys.playerMedia.tr(),
        );
        await _show(tester, media, delta: -250);
        await tester.tap(media);
        await tester.pumpAndSettle();
        final pickers = tester.widgetList<EvidencePicker>(
          find.byType(EvidencePicker),
        );
        expect(pickers.length, 2);
        expect(pickers.every((picker) => picker.isReadOnly), true);
        final imports = find.widgetWithText(
          FgButton,
          LocaleKeys.mediaImport.tr(),
        );
        await _show(tester, imports.first);
        expect(tester.widget<FgButton>(imports.first).isEnabled, false);
        await tester.tap(imports.first);
        await tester.pump();
        final delete = find.widgetWithText(
          FgButton,
          LocaleKeys.mediaDelete.tr(),
        );
        await _show(tester, delete);
        expect(tester.widget<FgButton>(delete).isEnabled, false);
        await tester.tap(delete);
        await tester.pump();
        expect(find.byType(AlertDialog), findsNothing);
        expect(repository.imports, 0);
        expect(repository.deletes, 0);
        expect(fixture.session.current.evidence, 'local');
        expect(fixture.session.current.notes, notes);
        expect(
          tester
              .widget<FgButton>(
                find.widgetWithText(FgButton, LocaleKeys.mediaView.tr()),
              )
              .isEnabled,
          true,
        );
        semantics.dispose();
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'consolidated workout slider/vertical gestures do not advance and target tick auto-pauses',
    (tester) async {
      final fixture = WorkoutTestFixture();
      await _pumpFeature(tester, WorkoutSessionPage(session: fixture.session));
      final setup = find.text(LocaleKeys.playerSetup.tr());
      await _show(tester, setup);
      await tester.tap(setup);
      await tester.pumpAndSettle();
      final slider = find.descendant(
        of: find.byKey(const ValueKey('player-setup')),
        matching: find.byType(Slider),
      );
      await _show(tester, slider);
      await tester.drag(slider, const Offset(90, 0));
      await tester.pumpAndSettle();
      expect(fixture.session.index, 0);
      expect(find.byType(AlertDialog), findsNothing);
      expect(fixture.session.current.clock.bpm, isNot(60));
      await tester.drag(find.byType(ListView).first, const Offset(0, -180));
      await tester.pumpAndSettle();
      expect(fixture.session.index, 0);
      expect(find.byType(AlertDialog), findsNothing);
      fixture.session.current.clock.setTempo(60);
      fixture.session.current.clock.start();
      fixture.times.first.advance(const Duration(seconds: 64));
      await tester.pump(const Duration(milliseconds: 40));
      expect(fixture.session.current.clock.running, false);
      expect(fixture.session.current.reachedTarget, true);
      expect(fixture.session.index, 0);
      expect(fixture.records, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
  for (final size in [
    const Size(320, 700),
    const Size(1040, 900),
    const Size(844, 390),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'consolidated workout light host ${size.width}x${size.height} at ${scale}x retains details and safe root Skip',
        (tester) async {
          await tester.binding.setSurfaceSize(size);
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final fixture = WorkoutTestFixture();
          final page = WorkoutSessionPage(session: fixture.session);
          await _pumpFeature(tester, page, textScale: scale);
          _expectDarkScreen(tester, page);
          expect(find.byType(PracticePlayerPage), findsOneWidget);
          expect(
            find.byKey(const ValueKey('workout-round-status')),
            findsOneWidget,
          );
          final details = find.text(LocaleKeys.workoutNavigationDetails.tr());
          await _show(tester, details);
          await tester.tap(details);
          await tester.pumpAndSettle();
          expect(
            find.textContaining(LocaleKeys.workoutNavigationHelp.tr()),
            findsOneWidget,
          );
          final reflection = find.text(LocaleKeys.playerReflection.tr());
          await _show(tester, reflection);
          await tester.tap(reflection);
          await tester.pumpAndSettle();
          final input = find.descendant(
            of: find.byKey(const ValueKey('player-reflection')),
            matching: find.byType(TextField),
          );
          await _show(tester, input);
          await tester.enterText(input, 'Retain on Cancel');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle();
          final next = find.byKey(const ValueKey('workout-next'));
          await _show(tester, next, delta: -400);
          await tester.tap(next);
          await tester.pumpAndSettle();
          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.text(LocaleKeys.workoutSkipBody.tr()), findsOneWidget);
          final dialog = tester.element(find.byType(AlertDialog));
          expect(Theme.of(dialog).brightness, Brightness.dark);
          final cancel = find.byKey(const ValueKey('workout-cancel'));
          await tester.ensureVisible(cancel);
          await tester.tap(cancel);
          await tester.pumpAndSettle();
          expect(fixture.session.index, 0);
          expect(fixture.session.current.notes, 'Retain on Cancel');
          expect(fixture.session.current.clock.running, false);
          expect(fixture.records, isEmpty);
          _expectDarkScreen(tester, page);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'consolidated workout swipe, semantic buttons, skip review and background keep one paused runtime',
    (tester) async {
      final fixture = WorkoutTestFixture();
      final page = WorkoutSessionPage(session: fixture.session);
      await _pumpFeature(tester, page);
      final semantics = tester.ensureSemantics();

      await tester.drag(
        find.byKey(const ValueKey('workout-round-status')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('workout-cancel')));
      await tester.pumpAndSettle();
      expect(fixture.session.index, 0);
      final next = find.byKey(const ValueKey('workout-next'));
      tester.binding.pipelineOwner.semanticsOwner!.performAction(
        tester.getSemantics(next).id,
        SemanticsAction.tap,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('workout-confirm')));
      await tester.pumpAndSettle();
      expect(fixture.session.index, 1);
      final round = fixture.session.current;
      round.muted = true;
      round.notes = 'Retained second round';
      round.clock.start();
      fixture.times[1].advance(const Duration(seconds: 14));
      await tester.pump(const Duration(milliseconds: 40));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(round.clock.running, false);
      expect(round.clock.activeDuration.inSeconds, 10);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.tap(find.byKey(const ValueKey('workout-previous')));
      await tester.pumpAndSettle();
      expect(fixture.session.current.status, daily.WorkoutRoundStatus.skipped);
      expect(find.byType(PracticePlayerPage), findsOneWidget);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(fixture.session.current, same(round));
      expect(round.notes, 'Retained second round');
      expect(round.clock.activeDuration.inSeconds, 10);
      expect(round.clock.running, false);
      expect(fixture.records, isEmpty);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    },
  );

  testWidgets(
    'consolidated workout exact failed-save Retry, completed review, truthful summary and Finish once',
    (tester) async {
      final writes = <PracticeRecord>[];
      final persisted = <String, PracticeRecord>{};
      var fail = true;
      final fixture = WorkoutTestFixture(
        count: 2,
        save: (record) async {
          writes.add(record);
          persisted[record.id] = record;
          if (fail) {
            fail = false;
            throw StateError('Acknowledgement lost');
          }
        },
      );
      fixture.completeTarget();
      fixture.session.current.notes = 'Target completed reflection';
      final launch = Builder(
        builder: (context) => FgButton(
          text: 'Launch session',
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => WorkoutSessionPage(session: fixture.session),
            ),
          ),
        ),
      );
      await _pumpFeature(tester, launch);
      await tester.tap(find.text('Launch session'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('workout-next')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('workout-save-error')), findsOneWidget);
      expect(fixture.session.index, 0);
      expect(persisted.length, 1);
      await tester.tap(find.byKey(const ValueKey('workout-skip')));
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.workoutAbandonBody.tr()), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('workout-cancel')));
      await tester.pumpAndSettle();
      expect(fixture.session.current.pending, same(writes.single));
      await tester.tap(find.byKey(const ValueKey('workout-retry')));
      await tester.pumpAndSettle();
      expect(writes[0], same(writes[1]));
      expect(persisted.length, 1);
      expect(fixture.session.index, 1);
      await tester.tap(find.byKey(const ValueKey('workout-previous')));
      await tester.pumpAndSettle();
      expect(
        fixture.session.current.status,
        daily.WorkoutRoundStatus.completed,
      );
      expect(fixture.session.current.notes, 'Target completed reflection');
      await tester.tap(find.byKey(const ValueKey('workout-next')));
      await tester.pumpAndSettle();
      expect(writes.length, 2);
      await tester.tap(find.byKey(const ValueKey('workout-skip')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('workout-confirm')));
      await tester.pumpAndSettle();
      expect(
        find.text(LocaleKeys.workoutSummaryCounts.tr(args: ['1', '1'])),
        findsOneWidget,
      );
      final summary = tester.widget<WorkoutSessionPage>(
        find.byType(WorkoutSessionPage),
      );
      _expectDarkScreen(tester, summary);
      await tester.tap(find.byKey(const ValueKey('workout-finish')));
      await tester.pumpAndSettle();
      expect(find.text('Launch session'), findsOneWidget);
      expect(find.byType(WorkoutSessionPage), findsNothing);
      expect(persisted.length, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'consolidated workout early exit Cancel retains and Leave discards only unsaved data',
    (tester) async {
      final fixture = WorkoutTestFixture(count: 2);
      fixture.completeTarget();
      await fixture.session.next('saved');
      fixture.session.current.notes = 'unsaved';
      final launch = Builder(
        builder: (context) => FgButton(
          text: 'Launch session',
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => WorkoutSessionPage(session: fixture.session),
            ),
          ),
        ),
      );
      await _pumpFeature(tester, launch);
      await tester.tap(find.text('Launch session'));
      await tester.pumpAndSettle();
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      unawaited(navigator.maybePop());
      await tester.pumpAndSettle();
      expect(
        find.text(LocaleKeys.workoutSessionLeaveBody.tr()),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('workout-cancel')));
      await tester.pumpAndSettle();
      expect(fixture.session.current.notes, 'unsaved');
      expect(fixture.records.length, 1);
      unawaited(navigator.maybePop());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('workout-confirm')));
      await tester.pumpAndSettle();
      expect(find.byType(WorkoutSessionPage), findsNothing);
      expect(fixture.records.length, 1);
      expect(tester.takeException(), isNull);
    },
  );
}

class _ReadonlyWorkoutMediaRepository extends _ContractMediaRepository {
  int imports = 0;
  int deletes = 0;
  @override
  Future<LocalMedia?> pickAndImportVideo() async {
    imports++;
    return null;
  }

  @override
  Future<void> delete(String id) async {
    deletes++;
  }
}
