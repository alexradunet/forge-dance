import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/skill_progression/prototype/model/skill_demo.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';

void main() {
  test('demo levels cover 0–99 monotonically and retain XP beyond the cap', () {
    for (var level = 0; level <= 99; level++) {
      expect(demoLevel(demoXpAtLevel(level)), level);
      if (level > 0) expect(demoLevel(demoXpAtLevel(level) - 1), level - 1);
    }
    expect(demoLevel(demoXpAtLevel(99) + 500), 99);
    final empty = SkillDemoState.fixture(DemoScenario.newHere);
    expect(empty.progress(DemoSkill.rhythm), 0);
    final capped = SkillDemoState.fixture(DemoScenario.near99)
        .award(demoSessionReward);
    expect(capped.levelOf(DemoSkill.rhythm), 99);
    expect(capped.remaining(DemoSkill.rhythm), 0);
    expect(capped.progress(DemoSkill.rhythm), 1);
    expect(capped.xpOf(DemoSkill.rhythm), greaterThan(demoXpAtLevel(99)));
  });

  test(
    'sample session awards once without inventing evidence or unrelated XP',
    () {
      final before = SkillDemoState.fixture(DemoScenario.sample);
      final after = before.award(demoSessionReward);
      expect(before.levelOf(DemoSkill.rhythm), 24);
      expect(after.levelOf(DemoSkill.rhythm), 25);
      expect(after.award(demoSessionReward), same(after));
      expect(after.milestones, before.milestones);
      expect(after.xpOf(DemoSkill.strength), before.xpOf(DemoSkill.strength));
      final evidence = after.toggleMilestone(DemoSkill.rhythm, 2);
      expect(evidence.xp, after.xp);
      expect(evidence.milestones, contains('rhythm:2'));
      expect(
        evidence.toggleMilestone(DemoSkill.rhythm, 2).milestones,
        after.milestones,
      );
    },
  );

  test('quest requires all unique steps and reward is idempotent', () {
    var state = SkillDemoState.fixture(DemoScenario.sample);
    expect(state.award(demoQuestReward), same(state));
    for (var i = 0; i < demoQuestSteps.length; i++) {
      state = state.completeQuestStep(i).completeQuestStep(i);
      expect(state.questSteps.length, i + 1);
    }
    expect(state.questComplete, isTrue);
    final after = state.award(demoQuestReward);
    expect(
      after.xpOf(DemoSkill.expression) - state.xpOf(DemoSkill.expression),
      80,
    );
    expect(after.award(demoQuestReward), same(after));
    expect(after.milestones, state.milestones);
  });

  test('quest roadmap references resolve to real lessons', () {
    for (final step in demoQuestSteps) {
      final module = allModules.singleWhere((module) => module.id == step.$2);
      expect(module.lessons.any((lesson) => lesson.title == step.$3), isTrue);
    }
  });
}
