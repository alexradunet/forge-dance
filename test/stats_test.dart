import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/learn/model/lesson.dart';
import 'package:forge_dance/features/learn/model/lesson_progress.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/stats/model/stats_rules.dart';

void main() {
  group('XP rules', () {
    test('awards XP by lesson type', () {
      expect(xpForLessonType(LessonType.theory), 20);
      expect(xpForLessonType(LessonType.drill), 30);
      expect(xpForLessonType(LessonType.movement), 40);
      expect(xpForLessonType(LessonType.experiment), 50);
      expect(xpForLessonType(LessonType.boss), 100);
    });

    test('only completed lessons earn XP', () {
      final lesson = hipHopFoundations.lessons.first; // theory, 20 XP
      final second = hipHopFoundations.lessons[1]; // movement, 40 XP

      expect(totalXpFrom(allModules, {}), 0);
      expect(
        totalXpFrom(allModules, {
          lesson.id: LessonProgress(
            lessonId: lesson.id,
            status: LessonStatus.completed,
          ),
          second.id: LessonProgress(
            lessonId: second.id,
            status: LessonStatus.inProgress,
          ),
        }),
        20,
      );
    });

    test('CALIBRATION: completing the whole catalog equals the Black Belt '
        'threshold — catalog changes must re-calibrate beltThresholds', () {
      final allCompleted = {
        for (final module in allModules)
          for (final lesson in module.lessons)
            lesson.id: LessonProgress(
              lessonId: lesson.id,
              status: LessonStatus.completed,
            ),
      };

      expect(totalXpFrom(allModules, allCompleted), beltThresholds.last);
    });
  });

  group('Belt levels', () {
    test('thresholds and names stay in lockstep and strictly increase', () {
      expect(beltThresholds.length, beltNames.length);
      for (var i = 1; i < beltThresholds.length; i++) {
        expect(beltThresholds[i], greaterThan(beltThresholds[i - 1]));
      }
    });

    test('belt boundaries', () {
      expect(beltIndexForXp(0), 0);
      expect(beltIndexForXp(239), 0);
      expect(beltIndexForXp(240), 1);
      expect(beltIndexForXp(beltThresholds.last), beltNames.length - 1);
      expect(beltIndexForXp(99999), beltNames.length - 1);
    });
  });

  group('Streak rules', () {
    final noon = DateTime(2026, 7, 6, 12);

    test('first ever activity starts a streak of 1', () {
      final result =
          nextStreak(currentStreak: 0, lastActivityDate: null, now: noon);
      expect(result.streak, 1);
      expect(result.activityDate, '2026-07-06');
    });

    test('same-day activity keeps the streak', () {
      final result = nextStreak(
          currentStreak: 5, lastActivityDate: '2026-07-06', now: noon);
      expect(result.streak, 5);
    });

    test('consecutive-day activity extends the streak', () {
      final result = nextStreak(
          currentStreak: 5, lastActivityDate: '2026-07-05', now: noon);
      expect(result.streak, 6);
      expect(result.activityDate, '2026-07-06');
    });

    test('a gap resets the streak to 1', () {
      final result = nextStreak(
          currentStreak: 12, lastActivityDate: '2026-07-03', now: noon);
      expect(result.streak, 1);
    });

    test('month boundary counts as consecutive', () {
      final firstOfMonth = DateTime(2026, 7, 1, 9);
      final result = nextStreak(
          currentStreak: 3, lastActivityDate: '2026-06-30', now: firstOfMonth);
      expect(result.streak, 4);
    });

    test('display streak survives only while alive (today or yesterday)', () {
      expect(
        displayStreak(
            persistedStreak: 7, lastActivityDate: '2026-07-06', now: noon),
        7,
      );
      expect(
        displayStreak(
            persistedStreak: 7, lastActivityDate: '2026-07-05', now: noon),
        7,
      );
      expect(
        displayStreak(
            persistedStreak: 7, lastActivityDate: '2026-07-01', now: noon),
        0,
      );
      expect(
        displayStreak(persistedStreak: 7, lastActivityDate: null, now: noon),
        0,
      );
    });
  });

  group('buildUserStats', () {
    final noon = DateTime(2026, 7, 6, 12);

    test('combines XP derivation with the persisted streak', () {
      final lesson = hipHopFoundations.lessons.first; // theory, 20 XP
      final stats = buildUserStats(
        modules: allModules,
        progress: {
          lesson.id: LessonProgress(
            lessonId: lesson.id,
            status: LessonStatus.completed,
          ),
        },
        persistedStreak: 3,
        lastActivityDate: '2026-07-06',
        now: noon,
      );

      expect(stats.totalXp, 20);
      expect(stats.level, 1);
      expect(stats.beltName, 'White');
      expect(stats.streakCount, 3);
      expect(stats.xpIntoLevel, 20);
      expect(stats.nextLevelXp, beltThresholds[1]);
      expect(stats.levelProgress, closeTo(20 / 240, 0.0001));
    });

    test('max belt caps progress at 1.0 with no next level', () {
      final allCompleted = {
        for (final module in allModules)
          for (final lesson in module.lessons)
            lesson.id: LessonProgress(
              lessonId: lesson.id,
              status: LessonStatus.completed,
            ),
      };
      final stats = buildUserStats(
        modules: allModules,
        progress: allCompleted,
        persistedStreak: 1,
        lastActivityDate: '2026-07-06',
        now: noon,
      );

      expect(stats.level, beltNames.length);
      expect(stats.beltName, 'Black');
      expect(stats.nextLevelXp, isNull);
      expect(stats.levelProgress, 1.0);
    });
  });

  group('formatXp', () {
    test('formats compactly', () {
      expect(formatXp(0), '0');
      expect(formatXp(840), '840');
      expect(formatXp(1000), '1.0k');
      expect(formatXp(2470), '2.5k');
    });
  });
}
