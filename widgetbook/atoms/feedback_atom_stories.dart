import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import '../story_canvas.dart';

List<WidgetbookNode> buildFeedbackAtomStories() {
  return [
    WidgetbookComponent(
      name: 'FgProgressBar',
      useCases: [
        WidgetbookUseCase(
          name: 'Progress states',
          builder: (_) => const _ProgressStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgSpinner',
      useCases: [
        WidgetbookUseCase(
          name: 'Sizes',
          builder: (_) => const _SpinnerStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgStatusDot',
      useCases: [
        WidgetbookUseCase(
          name: 'States',
          builder: (_) => const _StatusDotStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgLessonTimelineIndicator',
      useCases: [
        WidgetbookUseCase(
          name: 'Lesson states',
          builder: (_) => const _TimelineIndicatorStory(),
        ),
      ],
    ),
  ];
}

class _ProgressStory extends StatelessWidget {
  const _ProgressStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        for (final value in const [0.0, 0.25, 0.6, 1.0])
          StorySection(
            title: '${(value * 100).round()}%',
            child: FgProgressBar(
              value: value,
              semanticLabel:
                  'Training progress ${(value * 100).round()} percent',
            ),
          ),
      ],
    );
  }
}

class _SpinnerStory extends StatelessWidget {
  const _SpinnerStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        const StorySection(
          title: 'Sizes',
          child: Wrap(
            spacing: AppSpacing.xxxl,
            runSpacing: AppSpacing.xxl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FgSpinner(size: 16, strokeWidth: 2),
              FgSpinner(),
              FgSpinner(size: 40, strokeWidth: 4),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusDotStory extends StatelessWidget {
  const _StatusDotStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        const StorySection(
          title: 'Presence states',
          child: Wrap(
            spacing: AppSpacing.xxxl,
            runSpacing: AppSpacing.xxl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FgStatusDot(isLive: true),
              FgStatusDot(isLive: false),
              FgStatusDot(
                isLive: true,
                color: AppColors.electricBlue,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineIndicatorStory extends StatelessWidget {
  const _TimelineIndicatorStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Lesson states',
          child: Wrap(
            spacing: AppSpacing.xxxl,
            runSpacing: AppSpacing.xxl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final state in LessonNodeState.values)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FgLessonTimelineIndicator(state: state),
                    const SizedBox(height: AppSpacing.sm),
                    Text(state.name, style: AppTypography.caption),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
