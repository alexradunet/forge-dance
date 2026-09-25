import 'package:flutter/foundation.dart';

import '../model/skill_demo.dart';

/// In-memory only. Intentionally has no repository or production-provider access.
class SkillDemoController extends ValueNotifier<SkillDemoState> {
  SkillDemoController() : super(SkillDemoState.fixture(DemoScenario.sample));

  void reset(DemoScenario scenario) => value = SkillDemoState.fixture(scenario);
  void apply(DemoReward reward) => value = value.award(reward);
  void completeQuestStep(int index) => value = value.completeQuestStep(index);
  void toggleMilestone(DemoSkill skill, int index) =>
      value = value.toggleMilestone(skill, index);
}
