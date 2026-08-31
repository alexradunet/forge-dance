import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import '../story_canvas.dart';

List<WidgetbookNode> buildIdentityAtomStories() {
  return [
    WidgetbookComponent(
      name: 'FgAvatar',
      useCases: [
        WidgetbookUseCase(
          name: 'Sizes and states',
          builder: (_) => const _AvatarStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgBadge',
      useCases: [
        WidgetbookUseCase(
          name: 'Semantic matrix',
          builder: (_) => const _BadgeStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgLevelBadge',
      useCases: [
        WidgetbookUseCase(
          name: 'Levels',
          builder: (_) => const _LevelBadgeStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgLogo',
      useCases: [
        WidgetbookUseCase(
          name: 'Variants',
          builder: (_) => const _LogoStory(),
        ),
      ],
    ),
  ];
}

class _AvatarStory extends StatelessWidget {
  const _AvatarStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        const StorySection(
          title: 'Sizes',
          child: Wrap(
            spacing: AppSpacing.xxl,
            runSpacing: AppSpacing.xxl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FgAvatar.small(initials: 'FD'),
              FgAvatar.medium(initials: 'FD', isOnline: true),
              FgAvatar.large(
                initials: 'FD',
                level: 12,
                notificationCount: 3,
              ),
            ],
          ),
        ),
        const StorySection(
          title: 'Loading',
          child: FgAvatar.medium(isLoading: true),
        ),
      ],
    );
  }
}

class _BadgeStory extends StatelessWidget {
  const _BadgeStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        for (final variant in FgBadgeVariant.values)
          StorySection(
            title: variant.name,
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final color in FgBadgeColor.values)
                  FgBadge(
                    text: color.name.toUpperCase(),
                    variant: variant,
                    color: color,
                    shape: FgBadgeShape.pill,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _LevelBadgeStory extends StatelessWidget {
  const _LevelBadgeStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        const StorySection(
          title: 'Progression',
          child: Wrap(
            spacing: AppSpacing.xxl,
            runSpacing: AppSpacing.xxl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FgLevelBadge(level: 1, size: 24, showGlow: false),
              FgLevelBadge(level: 12, size: 32),
              FgLevelBadge(level: 99, size: 48),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoStory extends StatelessWidget {
  const _LogoStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        for (final variant in FgLogoVariant.values)
          StorySection(
            title: variant.name,
            child: Wrap(
              spacing: AppSpacing.xxxl,
              runSpacing: AppSpacing.xxl,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FgLogo(size: 40, variant: variant),
                FgLogo(
                  size: 40,
                  variant: variant,
                  color: FgLogoColor.white,
                ),
                FgLogo(
                  size: 40,
                  variant: variant,
                  color: FgLogoColor.black,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
