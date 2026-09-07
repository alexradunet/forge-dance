import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/stats/model/stats_rules.dart';

void main() {
  test('repeat practice extends a legacy streak once per day without earning a belt', () {
    final stats = buildUserStats(
      modules: const [],
      progress: const {},
      persistedStreak: 4,
      lastActivityDate: '2026-09-05',
      now: DateTime(2026, 9, 7, 12),
      minimumXp: 2400,
      practiceDates: const ['2026-09-07', '2026-09-06', '2026-09-07'],
    );
    expect(stats.streakCount, 6);
    expect(stats.totalXp, 2400);
    expect(stats.level, 1);
    expect(stats.levelProgress, 0);
  });

  test('future practice cannot keep a stale streak alive', () {
    final stats = buildUserStats(
      modules: const [],
      progress: const {},
      persistedStreak: 4,
      lastActivityDate: '2026-09-01',
      now: DateTime(2026, 9, 7, 12),
      practiceDates: const ['2026-09-03', '2026-09-08'],
    );
    expect(stats.streakCount, 0);
  });
}
