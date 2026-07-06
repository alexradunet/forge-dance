import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/learn/repository/progress_repository.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/repository/profile_repository.dart';
import 'package:forge_dance/features/stats/model/stats_rules.dart';
import 'package:forge_dance/features/workout/model/workout_session.dart';
import 'package:forge_dance/features/workout/repository/session_repository.dart';
import 'package:forge_dance/features/workout/repository/workout_catalog.dart';
import 'package:forge_dance/features/workout/ui/view_model/workout_view_model.dart';

class FakeSessionRepository extends SessionRepository {
  FakeSessionRepository([List<WorkoutSession> seed = const []])
      : store = {for (final s in seed) s.docKey: s},
        super(auth: null, firestore: null);

  final Map<String, WorkoutSession> store;

  @override
  Future<List<WorkoutSession>> getAll() async => store.values.toList();

  @override
  Future<void> complete(WorkoutSession session) async {
    store[session.docKey] = session;
  }
}

class FakeProfileRepository extends ProfileRepository {
  FakeProfileRepository() : super(auth: null, firestore: null);

  Profile? saved;

  @override
  Future<Profile?> get() async => saved;

  @override
  Future<void> update(Profile profile) async {
    saved = profile;
  }
}

ProviderContainer containerWith(
  FakeSessionRepository repository, {
  FakeProfileRepository? profileRepository,
}) {
  final container = ProviderContainer(
    overrides: [
      sessionRepositoryProvider.overrideWithValue(repository),
      profileRepositoryProvider
          .overrideWithValue(profileRepository ?? FakeProfileRepository()),
      // The stats coordinator also reads lesson progress; keep it off the
      // Firebase providers in tests via the nullable-deps real class.
      progressRepositoryProvider.overrideWithValue(
        const ProgressRepository(auth: null, firestore: null),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.listen(workoutViewModelProvider, (_, __) {});
  return container;
}

void main() {
  group('workout catalog', () {
    test('wodFor is deterministic and rotates daily through the catalog', () {
      final day1 = DateTime(2026, 7, 6);
      final day2 = DateTime(2026, 7, 7);

      expect(wodFor(day1), wodFor(day1));
      expect(wodFor(day1) == wodFor(day2), isFalse);

      // A full rotation covers every workout exactly once.
      final seen = {
        for (var i = 0; i < allWorkouts.length; i++)
          wodFor(day1.add(Duration(days: i))).id,
      };
      expect(seen.length, allWorkouts.length);
    });

    test('workout ids are unique and every workout has exercises', () {
      final ids = allWorkouts.map((w) => w.id).toSet();
      expect(ids.length, allWorkouts.length);
      for (final workout in allWorkouts) {
        expect(workout.exercises, isNotEmpty);
        expect(workout.xp, greaterThan(0));
      }
    });
  });

  group('workoutXpFrom', () {
    test('prices sessions by the catalog and ignores unknown workouts', () {
      final wod = allWorkouts.first;
      final sessions = [
        WorkoutSession(workoutId: wod.id, date: '2026-07-05'),
        WorkoutSession(workoutId: wod.id, date: '2026-07-06'),
        const WorkoutSession(workoutId: 'removed-workout', date: '2026-07-06'),
      ];

      expect(workoutXpFrom(allWorkouts, sessions), wod.xp * 2);
      expect(workoutXpFrom(allWorkouts, const []), 0);
    });
  });

  group('WorkoutViewModel', () {
    test('build exposes today\'s WOD and no completion for a fresh user',
        () async {
      final container = containerWith(FakeSessionRepository());

      final state = await container.read(workoutViewModelProvider.future);

      expect(state.wod, wodFor(DateTime.now()));
      expect(state.todayKey, dateKey(DateTime.now()));
      expect(state.wodCompletedToday, isFalse);
    });

    test('completeWod persists once per day and reports the dedupe',
        () async {
      final repository = FakeSessionRepository();
      final container = containerWith(repository);
      await container.read(workoutViewModelProvider.future);
      final notifier = container.read(workoutViewModelProvider.notifier);

      final awarded = await notifier.completeWod();
      expect(awarded, isTrue);

      final state = container.read(workoutViewModelProvider).value!;
      expect(state.wodCompletedToday, isTrue);
      expect(repository.store.length, 1);
      expect(
        repository.store.keys.single,
        '${state.todayKey}_${state.wodId}',
      );

      // Same day, same WOD: no second award, no duplicate session.
      final secondAward = await notifier.completeWod();
      expect(secondAward, isFalse);
      expect(repository.store.length, 1);
    });

    test('completing the WOD records XP and streak on the profile', () async {
      final profileRepository = FakeProfileRepository();
      final container = containerWith(
        FakeSessionRepository(),
        profileRepository: profileRepository,
      );
      final state = await container.read(workoutViewModelProvider.future);

      await container.read(workoutViewModelProvider.notifier).completeWod();

      final saved = profileRepository.saved;
      expect(saved, isNotNull);
      expect(saved!.xp, state.wod.xp);
      expect(saved.streakCount, 1);
      expect(saved.lastActivityDate, dateKey(DateTime.now()));
    });
  });

  group('SessionRepository (unconfigured Firebase)', () {
    test('reads empty and writes no-op instead of throwing', () async {
      const repository = SessionRepository(auth: null, firestore: null);

      expect(repository.isFirebaseConfigured, isFalse);
      expect(await repository.getAll(), isEmpty);
      await repository.complete(
        const WorkoutSession(workoutId: 'x', date: '2026-07-06'),
      );
    });
  });
}
