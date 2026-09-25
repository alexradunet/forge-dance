// THROWAWAY fixtures. No real progress is read, converted, or written.
import 'package:flutter/foundation.dart';

enum DemoSkill {
  rhythm('Rhythm', 'Find, maintain and play with timing.'),
  control('Body control', 'Initiate, stop and recover deliberately.'),
  coordination('Coordination', 'Connect available body areas.'),
  footwork('Footwork', 'Choose and transfer support.'),
  memory('Movement memory', 'Recall and adapt a phrase.'),
  expression('Expression', 'Make and communicate movement choices.'),
  mobility('Mobility', 'Explore a comfortable, usable range.'),
  strength('Strength', 'Develop controlled force with suitable support.'),
  stamina('Stamina', 'Manage effort, pacing and recovery.');

  const DemoSkill(this.label, this.description);
  final String label;
  final String description;
  bool get physical => index >= 6;
}

enum DemoScenario { sample, newHere, near99 }

/// Deliberately illustrative: NOT a calibrated training prescription or economy.
int demoXpAtLevel(int level) => 100 * level * level;
int demoLevel(int xp) {
  var level = 0;
  while (level < 99 && xp >= demoXpAtLevel(level + 1)) {
    level++;
  }
  return level;
}

@immutable
class DemoReward {
  const DemoReward(this.id, this.title, this.xp);
  final String id;
  final String title;
  final Map<DemoSkill, int> xp;
}

const demoSessionReward = DemoReward('groove-session', 'Groove exploration', {
  DemoSkill.rhythm: 120,
  DemoSkill.control: 80,
  DemoSkill.memory: 40,
});
const demoQuestReward = DemoReward('find-your-groove', 'Find Your Groove', {
  DemoSkill.rhythm: 60,
  DemoSkill.expression: 80,
});

const demoQuestSteps = [
  ('Find a comfortable pulse', 'common-time-weight', 'Find Pulse'),
  ('Explore bounce and rock', 'hip-hop-foundations', 'Bounce & Rock'),
  ('Connect a short phrase', 'common-quality-phrase', 'Learn a Phrase'),
  (
    'Recall it without a demonstration',
    'common-quality-phrase',
    'Recall & Adapt',
  ),
  (
    'Change one element to make it yours',
    'common-make-communicate',
    'Prompted Improvisation',
  ),
];

const demoMilestones = <DemoSkill, List<String>>{
  DemoSkill.rhythm: [
    'Maintain a steady pulse',
    'Recover after losing the beat',
    'Keep timing while changing direction',
  ],
  DemoSkill.control: ['Start and stop over a stable base'],
  DemoSkill.coordination: ['Connect two simple movement patterns'],
  DemoSkill.footwork: ['Transfer support before changing direction'],
  DemoSkill.memory: ['Recall a short phrase without following a model'],
  DemoSkill.expression: ['Adapt one movement quality intentionally'],
  DemoSkill.mobility: ['Choose a comfortable range and available support'],
  DemoSkill.strength: ['Control a suitable resistance without straining'],
  DemoSkill.stamina: ['Pace an activity and choose recovery early'],
};

@immutable
class SkillDemoState {
  SkillDemoState({
    required this.scenario,
    required Map<DemoSkill, int> xp,
    Set<String> appliedRewards = const {},
    Set<int> questSteps = const {},
    Set<String> milestones = const {},
  }) : xp = Map.unmodifiable(xp),
       appliedRewards = Set.unmodifiable(appliedRewards),
       questSteps = Set.unmodifiable(questSteps),
       milestones = Set.unmodifiable(milestones);

  factory SkillDemoState.fixture(DemoScenario scenario) {
    const levels = [24, 18, 15, 12, 9, 16, 14, 8, 11];
    return SkillDemoState(
      scenario: scenario,
      xp: {
        for (final skill in DemoSkill.values)
          skill: switch (scenario) {
            DemoScenario.newHere => 0,
            DemoScenario.near99 => demoXpAtLevel(99) - 60,
            DemoScenario.sample =>
              skill == DemoSkill.rhythm
                  ? demoXpAtLevel(25) - 60
                  : demoXpAtLevel(levels[skill.index]) + 120,
          },
      },
      milestones: scenario == DemoScenario.sample
          ? {'rhythm:0', 'rhythm:1'}
          : {},
    );
  }

  final DemoScenario scenario;
  final Map<DemoSkill, int> xp;
  final Set<String> appliedRewards;
  final Set<int> questSteps;
  final Set<String> milestones;
  int xpOf(DemoSkill skill) => xp[skill] ?? 0;
  int levelOf(DemoSkill skill) => demoLevel(xpOf(skill));
  int remaining(DemoSkill skill) => levelOf(skill) == 99
      ? 0
      : demoXpAtLevel(levelOf(skill) + 1) - xpOf(skill);
  double progress(DemoSkill skill) {
    final level = levelOf(skill);
    if (level == 99) return 1;
    return (xpOf(skill) - demoXpAtLevel(level)) /
        (demoXpAtLevel(level + 1) - demoXpAtLevel(level));
  }

  bool get questComplete => questSteps.length == demoQuestSteps.length;

  SkillDemoState award(DemoReward reward) {
    if (appliedRewards.contains(reward.id)) return this;
    if (reward.id == demoQuestReward.id && !questComplete) return this;
    return SkillDemoState(
      scenario: scenario,
      xp: {
        for (final skill in DemoSkill.values)
          skill: xpOf(skill) + (reward.xp[skill] ?? 0),
      },
      appliedRewards: {...appliedRewards, reward.id},
      questSteps: questSteps,
      milestones: milestones,
    );
  }

  SkillDemoState completeQuestStep(int index) {
    if (index < 0 || index >= demoQuestSteps.length) return this;
    return SkillDemoState(
      scenario: scenario,
      xp: xp,
      appliedRewards: appliedRewards,
      questSteps: {...questSteps, index},
      milestones: milestones,
    );
  }

  SkillDemoState toggleMilestone(DemoSkill skill, int index) {
    final key = '${skill.name}:$index';
    final updated = {...milestones};
    if (!updated.remove(key)) updated.add(key);
    return SkillDemoState(
      scenario: scenario,
      xp: xp,
      appliedRewards: appliedRewards,
      questSteps: questSteps,
      milestones: updated,
    );
  }
}
