import 'package:forge_dance/features/practice/model/practice.dart';
import 'package:forge_dance/features/practice/model/workout_session.dart';
import 'package:forge_dance/features/practice_player/model/practice_clock.dart';

/// Test-only monotonic source; never alters app storage or the system clock.
class WorkoutTestStopwatch implements Stopwatch {
  int micros = 0;
  bool active = false;
  void advance(Duration elapsed) {
    if (active) micros += elapsed.inMicroseconds;
  }

  @override
  int get elapsedMicroseconds => micros;
  @override
  int get elapsedMilliseconds => micros ~/ 1000;
  @override
  int get elapsedTicks => micros;
  @override
  int get frequency => 1000000;
  @override
  Duration get elapsed => Duration(microseconds: micros);
  @override
  bool get isRunning => active;
  @override
  void start() => active = true;
  @override
  void stop() => active = false;
  @override
  void reset() => micros = 0;
}

PracticePlan workoutTestPlan({int count = 3}) => PracticePlan(
  workoutId: 'fixture-workout',
  title: 'Isolated workout',
  focus: 'Session contract',
  dateKey: '2026-09-07',
  beltIndex: 0,
  blocks: List.generate(
    count,
    (i) => PracticeBlock(
      id: 'fixture-round-$i',
      title: 'Round ${i + 1} practice',
      level: 0,
      minutes: 1,
      bpm: 60,
      lessonId: 'fixture-lesson',
      cues: ['Keep your knees soft.', 'Step with comfortable range.'],
      adaptation: 'Seated: use small comfortable foot taps. Stop for sharp pain or dizziness.',
      workoutId: 'fixture-workout',
      workoutDate: '2026-09-07',
    ),
  ),
);

class WorkoutTestFixture {
  WorkoutTestFixture({
    int count = 3,
    Future<void> Function(PracticeRecord)? save,
  }) {
    session = WorkoutSession(
      plan: workoutTestPlan(count: count),
      save:
          save ??
          (record) async {
            records[record.id] = record;
          },
      clockFactory: (block) {
        final time = WorkoutTestStopwatch();
        times.add(time);
        return PracticeClock(bpm: block.bpm, stopwatch: time);
      },
      now: () => DateTime(2026, 9, 7, 23, 59),
    );
  }
  final times = <WorkoutTestStopwatch>[];
  final records = <String, PracticeRecord>{};
  late final WorkoutSession session;

  void completeTarget() {
    session.current.clock.start();
    times[session.index].advance(const Duration(seconds: 64));
    session.pause();
  }
}
