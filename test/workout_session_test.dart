import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/practice/model/practice.dart';
import 'package:forge_dance/features/practice/model/workout_session.dart';
import 'package:forge_dance/features/practice/repository/practice_repository.dart';
import 'package:forge_dance/features/practice/ui/practice_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/workout_session_fixture.dart';

class _CommitThenFailRepository extends PracticeRepository {
  bool fail = true;
  final writes = <PracticeRecord>[];
  @override
  Future<void> record(PracticeRecord record) async {
    writes.add(record);
    await super.record(record);
    if (fail) {
      fail = false;
      throw StateError('Acknowledgement lost after commit');
    }
  }
}

void main() {
  test(
    'unfinished target/count-in cannot advance; Cancel retains a paused draft',
    () async {
      final fixture = WorkoutTestFixture();
      final session = fixture.session;
      addTearDown(session.dispose);
      final round = session.current;
      round.notes = 'keep this draft';
      round.difficulty = 8;
      round.evidence = 'local-evidence';
      round.clock.start();
      fixture.times.first.advance(const Duration(seconds: 4));
      expect(round.clock.activeDuration, Duration.zero);
      expect(await session.next('guided'), WorkoutAdvance.confirmSkip);
      expect(session.index, 0);
      expect(round.clock.running, false);
      expect(session.beginConfirmation(), true);
      expect(await session.next('guided'), WorkoutAdvance.blocked);
      session.cancelConfirmation();
      expect(round.notes, 'keep this draft');
      expect(round.difficulty, 8);
      expect(round.evidence, 'local-evidence');
      expect(fixture.records, isEmpty);
      round.clock.start();
      fixture.times.first.advance(const Duration(seconds: 63));
      expect(await session.next('guided'), WorkoutAdvance.confirmSkip);
      expect(round.clock.activeDuration.inSeconds, 59);
      round.clock.start();
      fixture.times.first.advance(const Duration(seconds: 5));
      expect(await session.next('guided'), WorkoutAdvance.moved);
      expect(fixture.records.values.single.durationSeconds, 60);
      expect(session.current.clock.running, false);
    },
  );

  test('backward review retains current clock and every draft choice without duplicate saves', () async {
    final fixture = WorkoutTestFixture();
    final session = fixture.session;
    addTearDown(session.dispose);
    fixture.completeTarget();
    await session.next('first');
    final round = session.current;
    round.notes = 'reflection';
    round.difficulty = 7;
    round.evidence = 'evidence';
    round.demonstration = 'demo';
    round.muted = true;
    round.independent = true;
    round.showSchematic = true;
    round.clock.setTempo(120);
    round.clock.setPhrase(2, 5);
    round.clock.start();
    fixture.times[1].advance(const Duration(seconds: 12));
    session.previous();
    expect(session.current.status, WorkoutRoundStatus.completed);
    expect(round.clock.running, false);
    expect(round.clock.activeDuration.inSeconds, 10);
    await session.next('must not replace prior notes');
    expect(identical(session.current, round), true);
    expect(round.notes, 'reflection');
    expect(round.difficulty, 7);
    expect(round.evidence, 'evidence');
    expect(round.demonstration, 'demo');
    expect(round.muted && round.independent && round.showSchematic, true);
    expect(round.clock.bpm, 120);
    expect(round.clock.phraseStart, 2);
    expect(round.clock.phraseEnd, 5);
    expect(fixture.records.length, 1);
    expect(fixture.records.values.single.notes, 'first\n');
    expect(round.clock.running, false);
    expect(await session.next('second'), WorkoutAdvance.confirmSkip);
  });

  test('only explicit Skip resolves unfinished rounds; all skipped is not completed exercise', () async {
    final fixture = WorkoutTestFixture(count: 2);
    final session = fixture.session;
    addTearDown(session.dispose);
    session.confirmSkip();
    expect(session.index, 0);
    for (var i = 0; i < 2; i++) {
      session.current.notes = 'discard';
      session.beginConfirmation();
      session.confirmSkip();
    }
    expect(session.summary, true);
    expect(session.completed, 0);
    expect(session.skipped, 2);
    expect(fixture.records, isEmpty);
    expect(
      session.rounds.every((r) => r.notes.isEmpty && r.pending == null),
      true,
    );
    session.previous();
    expect(session.summary, false);
    expect(session.current.status, WorkoutRoundStatus.skipped);
    session.previous();
    expect(session.index, 0);
  });

  test('serialized save blocks repeated taps, previous, confirmation and freezes exact payload on failure', () async {
    final first = Completer<void>();
    final writes = <PracticeRecord>[];
    final fixture = WorkoutTestFixture(
      save: (record) {
        writes.add(record);
        return first.future;
      },
    );
    final session = fixture.session;
    addTearDown(session.dispose);
    fixture.completeTarget();
    session.current.notes = 'original';
    final write = session.next('guided');
    expect(session.saving, true);
    expect(await session.next('changed'), WorkoutAdvance.blocked);
    session.previous();
    expect(session.index, 0);
    expect(session.beginConfirmation(), false);
    first.completeError(StateError('pre-write failure'));
    await write;
    final pending = session.current.pending;
    expect(pending, same(writes.single));
    expect(session.error, isNotNull);
    expect(session.editable, false);
    await session.next('new variant is ignored');
    expect(writes.length, 2);
    expect(writes.last, same(pending));
    expect(writes.last.notes, 'guided\noriginal');
    expect(session.index, 0);
    session.beginConfirmation();
    session.cancelConfirmation();
    expect(session.current.pending, same(pending));
    session.beginConfirmation();
    session.confirmSkip();
    expect(session.skipped, 1);
    expect(session.abandonedSave, true);
  });

  test(
    'VM committed-then-failed retry keeps identity and stores only one record',
    () async {
      SharedPreferences.setMockInitialValues({});
      final repository = _CommitThenFailRepository();
      final container = ProviderContainer(
        overrides: [practiceRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(practiceViewModelProvider.future);
      final fixture = WorkoutTestFixture(
        count: 1,
        save: container.read(practiceViewModelProvider.notifier).record,
      );
      final session = fixture.session;
      addTearDown(session.dispose);
      fixture.completeTarget();
      await session.next('guided');
      expect(session.summary, false);
      expect(session.error, isNotNull);
      expect((await repository.getAll()).length, 1);
      await session.next('different retry text');
      expect(repository.writes[0], same(repository.writes[1]));
      expect((await repository.getAll()).length, 1);
      expect(session.completed, 1);
      expect(session.summary, true);
      session.previous();
      expect(session.editable, false);
      await session.next('review cannot resave');
      expect(repository.writes.length, 2);
    },
  );

  test('confirmation and background pause invalidate held preparation before clock/audio authorization', () async {
    final fixture = WorkoutTestFixture();
    final session = fixture.session;
    addTearDown(session.dispose);
    final round = session.current;
    final preparation = Completer<void>();
    final revision = session.playbackRevision;
    final heldStart = preparation.future.then(
      (_) => session.canStart(round, revision),
    );
    session.beginConfirmation();
    session.cancelConfirmation();
    preparation.complete();
    expect(await heldStart, false);
    final resumedRevision = session.playbackRevision;
    expect(session.canStart(round, resumedRevision), true);
    round.clock.start();
    fixture.times.first.advance(const Duration(seconds: 14));
    session.pause(); // same intent used by route lifecycle/background observer
    fixture.times.first.advance(const Duration(hours: 2));
    expect(round.clock.activeDuration.inSeconds, 10);
    expect(session.canStart(round, resumedRevision), false);
    session.beginConfirmation();
    session.confirmSkip();
    expect(session.canStart(round, session.playbackRevision), false);
    expect(session.rounds.every((r) => !r.clock.running), true);
  });

  test('frozen plan/date/identity and hard 24-hour record bound survive delayed sampling', () async {
    final fixture = WorkoutTestFixture(count: 1);
    final session = fixture.session;
    addTearDown(session.dispose);
    final original = session.plan;
    expect(() => original.blocks.clear(), throwsUnsupportedError);
    session.current.clock.start();
    fixture.times.first.advance(const Duration(hours: 26));
    session.pause();
    await session.next('seated adaptation');
    final record = fixture.records.values.single;
    expect(session.plan, same(original));
    expect(record.workoutId, original.workoutId);
    expect(record.workoutDate, '2026-09-07');
    expect(record.performedAt, DateTime(2026, 9, 7, 23, 59));
    expect(record.durationSeconds, 86400);
    record.validate();
  });
}
