// THROWAWAY: three profile hierarchies at /main/profile?variant=skills|journal|quests.
// Question: does independent experience + separate evidence feel motivating and
// understandable? All numbers, milestones and rewards below are fictional.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/design_system.dart';
import '../../../../routing/routes.dart';
import '../model/skill_demo.dart';
import 'skill_demo_controller.dart';

const skillPrototypeVariants = ['skills', 'journal', 'quests'];
const _layouts = ['A · Skill profile', 'B · Training journal', 'C · Quest-led'];
const _notice = 'Prototype · fictional sample data · nothing saved';
const _skillIcons = [
  Icons.music_note,
  Icons.accessibility_new,
  Icons.sync_alt,
  Icons.directions_walk,
  Icons.psychology_outlined,
  Icons.auto_awesome,
  Icons.open_with,
  Icons.fitness_center,
  Icons.favorite_outline,
];

class SkillProgressionPrototype extends StatefulWidget {
  const SkillProgressionPrototype({required this.variant, super.key});
  final String variant;
  @override
  State<SkillProgressionPrototype> createState() =>
      _SkillProgressionPrototypeState();
}

class _SkillProgressionPrototypeState extends State<SkillProgressionPrototype> {
  final _demo = SkillDemoController();
  int get _variant =>
      skillPrototypeVariants.indexOf(widget.variant).clamp(0, 2);
  @override
  void dispose() {
    _demo.dispose();
    super.dispose();
  }

  void _cycle(int delta) => context.replace(
    '${Routes.profile}?variant=${skillPrototypeVariants[(_variant + delta) % 3]}',
  );
  void _open(Widget page) =>
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) => FgImmersiveScaffold(
    bodyBuilder: (context) => Focus(
      onKeyEvent: (_, event) {
        final focused = FocusManager.instance.primaryFocus?.context;
        if (event is! KeyDownEvent ||
            ModalRoute.of(context)?.isCurrent == false ||
            focused?.widget is EditableText ||
            focused?.findAncestorWidgetOfExactType<EditableText>() != null) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _cycle(-1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _cycle(1);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.readingContentMax,
          ),
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder<SkillDemoState>(
                  valueListenable: _demo,
                  builder: (context, state, _) => ListView(
                    key: ValueKey(widget.variant),
                    padding: AppSpacing.allLG,
                    children: [
                      const AppHeader(title: 'Your dancer', subtitle: _notice),
                      const Text(
                        'Build experience in your own direction. Levels are not measured ability.',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (_variant == 0) ...[
                        _actions(context),
                        const SizedBox(height: AppSpacing.xl),
                        ..._skills(context, state),
                      ] else if (_variant == 1) ...[
                        FgRoundPanel(
                          label: 'Your training journal',
                          active: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                state.appliedRewards.contains(
                                      demoSessionReward.id,
                                    )
                                    ? 'Groove session added to demo'
                                    : 'A little practice, several skills',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              const Text(
                                'A sample session develops rhythm, control and movement memory. Rest never removes earned experience.',
                              ),
                              const SizedBox(height: AppSpacing.md),
                              FgButton(
                                text: 'Preview session rewards',
                                onPressed: () =>
                                    _open(_SessionPreview(demo: _demo)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _questCard(),
                        const SizedBox(height: AppSpacing.lg),
                        FgDetails(
                          key: const ValueKey('journal-skills'),
                          title: 'See all 9 skills',
                          child: Column(children: _skills(context, state)),
                        ),
                      ] else ...[
                        _questCard(),
                        const SizedBox(height: AppSpacing.lg),
                        const FgSectionHeading(
                          title: 'Skills for this quest',
                          subtitle: 'Develop several skills through one meaningful goal.',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        for (final skill in [
                          DemoSkill.rhythm,
                          DemoSkill.control,
                          DemoSkill.memory,
                          DemoSkill.expression,
                        ]) ...[
                          _skillCard(context, state, skill),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        FgButton(
                          text: 'Preview session rewards',
                          variant: FgButtonVariant.secondary,
                          onPressed: () => _open(_SessionPreview(demo: _demo)),
                        ),
                        FgDetails(
                          key: const ValueKey('quest-other-skills'),
                          title: 'Other skills & physical support',
                          child: Column(
                            children: [
                              for (final skill in DemoSkill.values.where(
                                (s) => ![
                                  DemoSkill.rhythm,
                                  DemoSkill.control,
                                  DemoSkill.memory,
                                  DemoSkill.expression,
                                ].contains(s),
                              )) ...[
                                _skillCard(context, state, skill),
                                const SizedBox(height: AppSpacing.md),
                              ],
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      FgButton(
                        text: 'How levels & milestones differ',
                        variant: FgButtonVariant.ghost,
                        onPressed: () => _explain(context),
                      ),
                      FgDetails(
                        key: const ValueKey('skill-prototype-state'),
                        title: 'Prototype controls & state',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Switching samples resets only this demo. No belt, assessment, or profile data is read or changed.',
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: [
                                for (final scenario in DemoScenario.values)
                                  FgFilterChip(
                                    label: switch (scenario) {
                                      DemoScenario.sample => 'Sample dancer',
                                      DemoScenario.newHere =>
                                        'New here · level 0',
                                      DemoScenario.near99 => 'Near level 99',
                                    },
                                    isSelected: state.scenario == scenario,
                                    onSelected: (_) => _demo.reset(scenario),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Layout: ${widget.variant}\nSample: ${state.scenario.name}\nDemo rewards: ${state.appliedRewards.join(", ")}\nQuest steps: ${state.questSteps.length}/${demoQuestSteps.length}\nMilestones: ${state.milestones.length}\nStorage writes: none\nXP curve: 100 × level² (placeholder, not calibrated)',
                            ),
                            for (final skill in DemoSkill.values)
                              Text(
                                '${skill.label}: ${state.xpOf(skill)} XP · ${state.levelOf(skill)}/99',
                              ),
                          ],
                        ),
                      ),
                      FgButton(
                        text: 'Back to real profile',
                        variant: FgButtonVariant.ghost,
                        onPressed: () => context.go(Routes.profile),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: AppSpacing.allSM,
                child: FgCard(
                  immersive: true,
                  padding: AppSpacing.allSM,
                  child: Row(
                    children: [
                      FgIconButton(
                        icon: Icons.chevron_left,
                        semanticLabel: 'Previous skill layout',
                        onPressed: () => _cycle(-1),
                      ),
                      Expanded(
                        child: Text(
                          _layouts[_variant],
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FgIconButton(
                        icon: Icons.chevron_right,
                        semanticLabel: 'Next skill layout',
                        onPressed: () => _cycle(1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _actions(BuildContext context) => Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.sm,
    children: [
      FgButton(
        text: 'Preview session rewards',
        onPressed: () => _open(_SessionPreview(demo: _demo)),
      ),
      FgButton(
        text: 'Find Your Groove quest',
        variant: FgButtonVariant.secondary,
        onPressed: () => _open(_QuestPreview(demo: _demo)),
      ),
    ],
  );

  Widget _questCard() => FgProgramCard(
    title: 'Find Your Groove',
    label: 'Quest · sample',
    summary: 'Find a pulse, connect a phrase, then make it yours.',
    details:
        '${_demo.value.questSteps.length} of ${demoQuestSteps.length} demo steps explored',
    actionLabel: 'Explore quest',
    onTap: () => _open(_QuestPreview(demo: _demo)),
  );

  List<Widget> _skills(BuildContext context, SkillDemoState state) => [
    const FgSectionHeading(title: 'Dance skills'),
    const SizedBox(height: AppSpacing.md),
    FgProgramCardLayout(
      children: [
        for (final skill in DemoSkill.values.where((s) => !s.physical))
          _skillCard(context, state, skill),
      ],
    ),
    const SizedBox(height: AppSpacing.xl),
    const FgSectionHeading(
      title: 'Physical support',
      subtitle: 'Optional training experience—not a strength, flexibility or health score.',
    ),
    const SizedBox(height: AppSpacing.md),
    FgProgramCardLayout(
      children: [
        for (final skill in DemoSkill.values.where((s) => s.physical))
          _skillCard(context, state, skill),
      ],
    ),
  ];

  Widget _skillCard(
    BuildContext context,
    SkillDemoState state,
    DemoSkill skill,
  ) => FgCard(
    key: ValueKey('demo-skill-${skill.name}'),
    immersive: true,
    semanticLabel:
        '${skill.label}, experience level ${state.levelOf(skill)} of 99, view skill',
    onTap: () => _open(_SkillPreview(demo: _demo, skill: skill)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              _skillIcons[skill.index],
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                skill.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '${state.levelOf(skill)} / 99',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        FgProgressBar(value: state.progress(skill)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          state.levelOf(skill) == 99
              ? 'Level cap · experience retained'
              : '${state.remaining(skill)} XP to next level',
        ),
      ],
    ),
  );
}

void _explain(BuildContext context) => FgImmersiveScaffold.showModal<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Experience ≠ ability'),
    content: const SingleChildScrollView(
      child: Text(
        'Levels 0–99 celebrate recorded practice, not measured dance or physical ability. Level 0 means no experience recorded here—not no ability.\n\nMilestones describe specific capabilities and their evidence source. Self-assessed is not coach-verified.\n\nRest does not remove XP. Intensity, pain and extreme range do not earn bonuses. Physical support skills are optional.\n\nAll numbers and evidence in this preview are fictional. The XP curve and award amounts are illustrative, not a proposed training schedule. Existing belts and history are untouched.',
      ),
    ),
    actions: [
      FgButton(text: 'Got it', onPressed: () => Navigator.pop(context)),
    ],
  ),
);

class _DemoPage extends StatelessWidget {
  const _DemoPage({
    required this.title,
    required this.demo,
    required this.content,
  });
  final String title;
  final SkillDemoController demo;
  final List<Widget> Function(BuildContext, SkillDemoState) content;
  @override
  Widget build(BuildContext context) => FgImmersiveScaffold(
    title: title,
    bodyBuilder: (context) => FgReadingBody(
      child: ValueListenableBuilder<SkillDemoState>(
        valueListenable: demo,
        builder: (context, state, _) => ListView(
          padding: AppSpacing.allLG,
          children: [
            const Text(_notice),
            const SizedBox(height: AppSpacing.lg),
            ...content(context, state),
          ],
        ),
      ),
    ),
  );
}

class _SkillPreview extends StatelessWidget {
  const _SkillPreview({required this.demo, required this.skill});
  final SkillDemoController demo;
  final DemoSkill skill;
  @override
  Widget build(BuildContext context) => _DemoPage(
    title: skill.label,
    demo: demo,
    content: (context, state) => [
      FgRoundPanel(
        label: 'Practice experience',
        active: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Level ${state.levelOf(skill)} / 99',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(skill.description),
            const SizedBox(height: AppSpacing.lg),
            FgProgressBar(value: state.progress(skill)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${state.xpOf(skill)} demo XP · ${state.levelOf(skill) == 99 ? "level cap reached" : "${state.remaining(skill)} to next level"}',
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      const Text(
        'Experience is not a capability score. Milestones stay separate.',
      ),
      if (skill.physical) ...[
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Standing, seated and supported practice can all count. Stop for pain, dizziness or unusual breathlessness. No XP bonus for pushing harder.',
        ),
      ],
      const SizedBox(height: AppSpacing.xl),
      const FgSectionHeading(
        title: 'Capability milestones',
        subtitle: 'Fictional self-assessment examples. Not verified evidence.',
      ),
      for (final (index, label) in demoMilestones[skill]!.indexed) ...[
        const SizedBox(height: AppSpacing.md),
        FgCard(
          immersive: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.milestones.contains('${skill.name}:$index')
                    ? 'Self-assessed · demo evidence'
                    : 'Not yet demonstrated in this demo',
              ),
              FgButton(
                text: state.milestones.contains('${skill.name}:$index')
                    ? 'Remove demo evidence'
                    : 'Add demo self-assessment',
                variant: FgButtonVariant.ghost,
                onPressed: () => demo.toggleMilestone(skill, index),
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: AppSpacing.lg),
      FgButton(
        text: 'How levels & milestones differ',
        variant: FgButtonVariant.secondary,
        onPressed: () => _explain(context),
      ),
    ],
  );
}

class _SessionPreview extends StatelessWidget {
  const _SessionPreview({required this.demo});
  final SkillDemoController demo;
  @override
  Widget build(BuildContext context) => _DemoPage(
    title: 'Session rewards',
    demo: demo,
    content: (context, state) {
      final applied = state.appliedRewards.contains(demoSessionReward.id);
      final after = state.award(demoSessionReward);
      return [
        FgSectionHeading(
          title: 'Groove exploration',
          subtitle: applied
              ? 'Added once to this demo. Nothing was saved.'
              : 'Illustrative session summary—not a real recorded workout.',
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'A comfortable pulse, a controlled stop, and recalling a short pattern develop different skills. These XP amounts are placeholders.',
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final entry in demoSessionReward.xp.entries) ...[
          FgCard(
            immersive: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  entry.key.label,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '+${entry.value} demo XP',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  applied
                      ? 'Now level ${state.levelOf(entry.key)} / 99'
                      : 'Level ${state.levelOf(entry.key)} → ${after.levelOf(entry.key)}',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const Text(
          'No capability milestone or lesson prerequisite changes. Reopening this summary cannot award it twice.',
        ),
        const SizedBox(height: AppSpacing.lg),
        FgButton(
          key: const ValueKey('apply-demo-session'),
          text: applied ? 'Applied to demo' : 'Apply to demo profile',
          onPressed: applied ? null : () => demo.apply(demoSessionReward),
        ),
        const SizedBox(height: AppSpacing.sm),
        FgButton(
          text: 'Back to skills',
          variant: FgButtonVariant.secondary,
          onPressed: () => Navigator.pop(context),
        ),
      ];
    },
  );
}

class _QuestPreview extends StatelessWidget {
  const _QuestPreview({required this.demo});
  final SkillDemoController demo;
  @override
  Widget build(BuildContext context) => _DemoPage(
    title: 'Find Your Groove',
    demo: demo,
    content: (context, state) => [
      FgRoundPanel(
        label: 'Quest · sample',
        active: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${state.questSteps.length} / ${demoQuestSteps.length} demo steps',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'Make a short phrase your own. There is no deadline and no penalty for rest.',
            ),
            const SizedBox(height: AppSpacing.md),
            FgProgressBar(
              value: state.questSteps.length / demoQuestSteps.length,
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      const Text(
        'This preview marks fictional quest steps only. Real lessons keep their prerequisites. Use a comfortable range and available support; stop for pain, dizziness or unusual breathlessness.',
      ),
      const SizedBox(height: AppSpacing.lg),
      for (final (index, step) in demoQuestSteps.indexed) ...[
        FgCard(
          immersive: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${index + 1}. ${step.$1}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Related lesson: ${step.$3}'),
              FgButton(
                key: ValueKey('locate-quest-$index'),
                text: 'Locate in roadmap preview',
                variant: FgButtonVariant.ghost,
                onPressed: () => context.push(
                  Uri(
                    path: Routes.explore,
                    queryParameters: {'variant': 'roadmap', 'search': step.$3},
                  ).toString(),
                ),
              ),
              FgButton(
                key: ValueKey('demo-quest-step-$index'),
                text: state.questSteps.contains(index)
                    ? 'Explored in demo'
                    : 'Mark demo step explored',
                variant: FgButtonVariant.secondary,
                onPressed: state.questSteps.contains(index)
                    ? null
                    : () => demo.completeQuestStep(index),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
      const FgSectionHeading(
        title: 'Quest reward',
        subtitle: '+60 Rhythm XP · +80 Expression XP · demo amounts',
      ),
      const SizedBox(height: AppSpacing.md),
      Text(
        state.questComplete
            ? 'Demo quest complete. Capability milestones remain separate.'
            : 'Explore all five demo steps to preview this reward.',
      ),
      const SizedBox(height: AppSpacing.md),
      FgButton(
        key: const ValueKey('claim-demo-quest'),
        text: state.appliedRewards.contains(demoQuestReward.id)
            ? 'Demo reward claimed'
            : 'Claim demo quest reward',
        onPressed:
            !state.questComplete ||
                state.appliedRewards.contains(demoQuestReward.id)
            ? null
            : () => demo.apply(demoQuestReward),
      ),
    ],
  );
}
