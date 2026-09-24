import 'package:flutter/foundation.dart';

import '../../practice_player/model/practice_clock.dart';
import 'practice.dart';

enum WorkoutRoundStatus { current, completed, skipped }

enum WorkoutAdvance { moved, confirmSkip, blocked }

/// Transient round state. Only the displayed round has a mounted media runtime.
class WorkoutRound {
  WorkoutRound(this.block, this.clock, this.performedAt);
  final PracticeBlock block;
  final PracticeClock clock;
  final DateTime performedAt;
  WorkoutRoundStatus status = WorkoutRoundStatus.current;
  String notes = '';
  bool muted = false;
  bool independent = false;
  bool showSchematic = false;
  int difficulty = 5;
  String? evidence;
  String? demonstration;
  PracticeRecord? pending;
  bool get reachedTarget =>
      clock.activeDuration.inSeconds >= block.minutes * 60;

  PracticeRecord freezeRecord(String variant) => pending ??= PracticeRecord(
    id: PracticeRecord.createId(),
    blockId: block.id,
    title: block.title,
    lessonId: block.lessonId,
    vocabularyId: block.vocabularyId,
    workoutId: block.workoutId,
    workoutDate: block.workoutDate,
    category: block.category,
    level: block.level,
    performedAt: performedAt,
    durationSeconds: clock.activeDuration.inSeconds.clamp(1, 86400),
    bpm: clock.bpm,
    attempts: clock.attempts.clamp(1, 10000),
    difficulty: difficulty,
    notes: '$variant\n${notes.trim()}',
    evidenceId: evidence,
  );
}

/// One immutable plan, one unresolved frontier, and one frozen write at a time.
/// A failed write may already be committed: retries must use the same object.
class WorkoutSession extends ChangeNotifier {
  WorkoutSession({
    required this.plan,
    required this.save,
    PracticeClock Function(PracticeBlock)? clockFactory,
    DateTime Function()? now,
  }) : rounds = List.unmodifiable(
         plan.blocks.map(
           (block) => WorkoutRound(
             block,
             clockFactory?.call(block) ?? PracticeClock(bpm: block.bpm),
             (now ?? DateTime.now)(),
           ),
         ),
       ) {
    if (rounds.isEmpty) throw ArgumentError('A workout needs rounds');
    for (final round in rounds) {
      round.clock.addListener(_tick);
    }
  }

  final PracticePlan plan;
  final List<WorkoutRound> rounds;
  final Future<void> Function(PracticeRecord) save;
  int index = 0;
  bool saving = false;
  bool confirming = false;
  bool summary = false;
  bool abandonedSave = false;
  Object? error;
  bool _disposed = false;
  int _playbackRevision = 0;
  int get playbackRevision => _playbackRevision;

  bool canStart(WorkoutRound round, int revision) =>
      !_disposed &&
      !summary &&
      identical(current, round) &&
      revision == _playbackRevision &&
      editable &&
      !round.reachedTarget;
  WorkoutRound get current => rounds[index];
  int get completed =>
      rounds.where((r) => r.status == WorkoutRoundStatus.completed).length;
  int get skipped =>
      rounds.where((r) => r.status == WorkoutRoundStatus.skipped).length;
  bool get editable =>
      !saving &&
      !confirming &&
      current.pending == null &&
      current.status == WorkoutRoundStatus.current;

  void _tick() {
    if (current.clock.running &&
        (current.reachedTarget ||
            current.clock.activeDuration.inSeconds >= 86400)) {
      current.clock.pause();
    }
    if (!_disposed) notifyListeners();
  }

  void pause() {
    _playbackRevision++;
    current.clock.pause();
    notifyListeners();
  }

  void previous() {
    if (saving ||
        confirming ||
        (current.pending != null &&
            current.status == WorkoutRoundStatus.current)) {
      return;
    }
    pause();
    if (summary) {
      summary = false;
    } else if (index > 0) {
      index--;
    }
    notifyListeners();
  }

  Future<WorkoutAdvance> next(String variant) async {
    if (saving || confirming || summary) return WorkoutAdvance.blocked;
    pause();
    if (current.status != WorkoutRoundStatus.current) {
      _advance();
      return WorkoutAdvance.moved;
    }
    if (!current.reachedTarget) return WorkoutAdvance.confirmSkip;
    final record = current.freezeRecord(variant);
    saving = true;
    error = null;
    notifyListeners();
    try {
      await save(record);
      if (_disposed) return WorkoutAdvance.blocked;
      current.status = WorkoutRoundStatus.completed;
      saving = false;
      _advance();
      return WorkoutAdvance.moved;
    } catch (failure) {
      if (!_disposed) error = failure;
      return WorkoutAdvance.blocked;
    } finally {
      saving = false;
      if (!_disposed) notifyListeners();
    }
  }

  bool beginConfirmation() {
    if (saving || confirming) return false;
    pause();
    confirming = true;
    notifyListeners();
    return true;
  }

  void cancelConfirmation() {
    confirming = false;
    notifyListeners();
  }

  /// Call only after an explicit destructive confirmation. A failed write may
  /// exist in the log already; abandoning never deletes persisted records.
  void confirmSkip() {
    if (!confirming || saving) return;
    confirming = false;
    if (current.status == WorkoutRoundStatus.current) {
      abandonedSave = abandonedSave || current.pending != null;
      current.pending = null;
      current.notes = '';
      current.evidence = null;
      current.status = WorkoutRoundStatus.skipped;
      error = null;
      _advance();
    } else {
      notifyListeners();
    }
  }

  void _advance() {
    if (index == rounds.length - 1) {
      summary = true;
    } else {
      index++;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    for (final round in rounds) {
      round.clock.removeListener(_tick);
      round.clock.dispose();
    }
    super.dispose();
  }
}
