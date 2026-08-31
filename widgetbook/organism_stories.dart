import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import 'story_canvas.dart';

List<WidgetbookNode> buildOrganismStories() {
  return [
    WidgetbookCategory(
      name: 'Navigation',
      children: [
        _component('AppHeader', (_) => const _HeaderStory()),
        _component('AppBottomNav', (_) => const _BottomNavStory()),
      ],
    ),
    WidgetbookCategory(
      name: 'Progress',
      children: [
        _component('ProgressSection', (_) => const _ProgressSectionStory()),
        _component('StatsBreakdown', (_) => const _StatsStory()),
      ],
    ),
    WidgetbookCategory(
      name: 'Modals',
      children: [
        _component('ForgeAlertDialog', (_) => const _AlertStory()),
        _component('ForgeBottomSheet', (_) => const _BottomSheetStory()),
        _component('ForgeActionSheet', (_) => const _ActionSheetStory()),
        _component('FgFilterSheet', (_) => const _FilterSheetStory()),
      ],
    ),
    WidgetbookCategory(
      name: 'Lessons',
      children: [
        _component('LessonPathTimeline', (_) => const _LessonPathStory()),
      ],
    ),
  ];
}

WidgetbookComponent _component(
  String name,
  Widget Function(BuildContext) builder,
) {
  return WidgetbookComponent(
    name: name,
    useCases: [WidgetbookUseCase(name: 'States', builder: builder)],
  );
}

class _HeaderStory extends StatelessWidget {
  const _HeaderStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Screen header',
          child: AppHeader(
            title: 'Learn',
            subtitle: 'Foundation path',
            onBack: () {},
            rightSlot: const FgAvatar.small(initials: 'FD'),
          ),
        ),
      ],
    );
  }
}

class _BottomNavStory extends StatefulWidget {
  const _BottomNavStory();

  @override
  State<_BottomNavStory> createState() => _BottomNavStoryState();
}

class _BottomNavStoryState extends State<_BottomNavStory> {
  int _index = 2;

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Application navigation',
          child: AppBottomNav(
            currentIndex: _index,
            onTabChange: (index) => setState(() => _index = index),
          ),
        ),
      ],
    );
  }
}

class _ProgressSectionStory extends StatelessWidget {
  const _ProgressSectionStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Training progress',
          child: ProgressSection(
            title: 'This week',
            actionLabel: 'View stats',
            onAction: () {},
            stats: [
              StatCardData(label: 'Sessions', value: '4'),
              StatCardData(label: 'Minutes', value: '86'),
              StatCardData(label: 'Streak', value: '7', unit: ' days'),
            ],
            levelProgress: ProgressData(
              label: 'Orange belt',
              current: 680,
              target: 1000,
              message: '320 XP until the next belt',
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsStory extends StatelessWidget {
  const _StatsStory();

  @override
  Widget build(BuildContext context) {
    return const StoryCanvas(
      children: [
        StorySection(
          title: 'XP summary',
          child: StatsBreakdown(
            totalXP: 12480,
            trend: '+12%',
            weeklyGoal: 800,
            rank: 42,
          ),
        ),
      ],
    );
  }
}

class _AlertStory extends StatelessWidget {
  const _AlertStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Alert dialog',
          description: 'Launches in its real modal route and barrier.',
          child: Align(
            alignment: Alignment.centerLeft,
            child: FgButton(
              text: 'Show alert',
              onPressed: () {
                ForgeAlertDialog.show(
                  context: context,
                  title: 'Leave session?',
                  message: 'Your current exercise progress will be saved.',
                  icon: Icons.warning_amber_rounded,
                  primaryActionLabel: 'Leave',
                  secondaryActionLabel: 'Keep training',
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomSheetStory extends StatelessWidget {
  const _BottomSheetStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Bottom sheet',
          description: 'Launches with the production modal behavior.',
          child: Align(
            alignment: Alignment.centerLeft,
            child: FgButton(
              text: 'Show bottom sheet',
              onPressed: () {
                ForgeBottomSheet.show<void>(
                  context: context,
                  title: 'Session options',
                  resetLabel: 'Reset',
                  actionLabel: 'Apply',
                  child: Padding(
                    padding: AppSpacing.allLG,
                    child: Text(
                      'Configure the current training session.',
                      style: AppTypography.body,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionSheetStory extends StatelessWidget {
  const _ActionSheetStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Action sheet',
          child: Align(
            alignment: Alignment.centerLeft,
            child: FgButton(
              text: 'Show actions',
              variant: FgButtonVariant.secondary,
              onPressed: () {
                ForgeActionSheet.show<void>(
                  context: context,
                  title: 'Lesson actions',
                  actions: const [
                    ForgeActionSheetItem(
                      label: 'Save for later',
                      icon: Icons.bookmark_border_rounded,
                    ),
                    ForgeActionSheetItem(
                      label: 'Share lesson',
                      icon: Icons.share_outlined,
                    ),
                    ForgeActionSheetItem(
                      label: 'Remove download',
                      icon: Icons.delete_outline_rounded,
                      isDestructive: true,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterSheetStory extends StatelessWidget {
  const _FilterSheetStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Filter sheet',
          child: Align(
            alignment: Alignment.centerLeft,
            child: FgButton(
              text: 'Filter library',
              icon: const Icon(Icons.tune_rounded),
              onPressed: () {
                FgFilterSheet.show(
                  context: context,
                  sections: const {
                    'Difficulty': ['Beginner', 'Intermediate', 'Advanced'],
                    'Style': ['Hip hop', 'House', 'Breaking'],
                  },
                  selectedFilters: const {'Difficulty': 'Beginner'},
                  onFilterSelected: (_, __) {},
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _LessonPathStory extends StatelessWidget {
  const _LessonPathStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Foundation path',
          child: LessonPathTimeline(
            onNavigate: (_) {},
            nodes: const [
              LessonNode(
                title: 'Groove theory',
                type: LessonNodeType.theory,
                state: LessonNodeState.completed,
                duration: '6 min',
                progress: 1,
              ),
              LessonNode(
                title: 'Bounce control',
                type: LessonNodeType.drill,
                state: LessonNodeState.completed,
                duration: '8 min',
                progress: 1,
              ),
              LessonNode(
                title: 'Step-touch patterns',
                type: LessonNodeType.movement,
                state: LessonNodeState.current,
                duration: '12 min',
                progress: 0.45,
              ),
              LessonNode(
                title: 'Freestyle experiment',
                type: LessonNodeType.experiment,
                state: LessonNodeState.locked,
                duration: '10 min',
              ),
              LessonNode(
                title: 'Foundation challenge',
                type: LessonNodeType.boss,
                state: LessonNodeState.locked,
                duration: '20 min',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
