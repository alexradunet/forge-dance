import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import 'story_canvas.dart';

List<WidgetbookNode> buildFoundationStories() {
  return [
    WidgetbookComponent(
      name: 'Color palette',
      useCases: [
        WidgetbookUseCase(
          name: 'Brand and semantic colors',
          builder: (_) => const _ColorPalette(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Typography',
      useCases: [
        WidgetbookUseCase(
          name: 'Type scale',
          builder: (_) => const _TypographyScale(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Spacing',
      useCases: [
        WidgetbookUseCase(
          name: '4px scale',
          builder: (_) => const _SpacingScale(),
        ),
      ],
    ),
  ];
}

class _ColorPalette extends StatelessWidget {
  const _ColorPalette();

  static const colors = <(String, Color)>[
    ('Forge Fire', AppColors.forgeFire),
    ('Electric Blue', AppColors.electricBlue),
    ('Legend Gold', AppColors.legendGold),
    ('Mystic Purple', AppColors.mysticPurple),
    ('Growth Green', AppColors.growthGreen),
    ('Passion Red', AppColors.passionRed),
    ('Warning Amber', AppColors.warningAmber),
    ('Deep background', AppColors.bgDeep),
    ('Dark surface', AppColors.surfaceDark),
    ('Card surface', AppColors.surfaceCard),
    ('Light surface', AppColors.surfaceLight),
  ];

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Forge palette',
          description: 'Brand, feedback, and dark-surface roles.',
          child: Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            children: [for (final color in colors) _ColorTile(color: color)],
          ),
        ),
        StorySection(
          title: 'Neutral scale',
          description: 'Shared contrast ladder from gray 50 through gray 950.',
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              _ColorTile(color: ('Gray 50', AppColors.gray50)),
              _ColorTile(color: ('Gray 100', AppColors.gray100)),
              _ColorTile(color: ('Gray 200', AppColors.gray200)),
              _ColorTile(color: ('Gray 300', AppColors.gray300)),
              _ColorTile(color: ('Gray 400', AppColors.gray400)),
              _ColorTile(color: ('Gray 500', AppColors.gray500)),
              _ColorTile(color: ('Gray 600', AppColors.gray600)),
              _ColorTile(color: ('Gray 700', AppColors.gray700)),
              _ColorTile(color: ('Gray 800', AppColors.gray800)),
              _ColorTile(color: ('Gray 900', AppColors.gray900)),
              _ColorTile(color: ('Gray 950', AppColors.gray950)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorTile extends StatelessWidget {
  const _ColorTile({required this.color});

  final (String, Color) color;

  @override
  Widget build(BuildContext context) {
    final (name, value) = color;
    final foreground =
        ThemeData.estimateBrightnessForColor(value) == Brightness.dark
            ? AppColors.crystalWhite
            : AppColors.gray950;

    return Container(
      width: AppSpacing.huge4 * 2,
      padding: AppSpacing.allLG,
      decoration: BoxDecoration(
        color: value,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: AppTypography.bodySmall.copyWith(color: foreground)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '#${value.value.toRadixString(16).substring(2).toUpperCase()}',
            style: AppTypography.monoSmall.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

class _TypographyScale extends StatelessWidget {
  const _TypographyScale();

  @override
  Widget build(BuildContext context) {
    final styles = <(String, TextStyle)>[
      ('H1 · Bebas Neue · 48', AppTypography.h1),
      ('H2 · Bebas Neue · 36', AppTypography.h2),
      ('H3 · Inter Semibold · 30', AppTypography.h3),
      ('H4 · Inter Semibold · 24', AppTypography.h4),
      ('H5 · Inter Medium · 20', AppTypography.h5),
      ('H6 · Inter Medium · 18', AppTypography.h6),
      ('Body Large · Inter · 18', AppTypography.bodyLarge),
      ('Body · Inter · 16', AppTypography.body),
      ('Body Small · Inter · 14', AppTypography.bodySmall),
      ('Caption · Inter · 12', AppTypography.caption),
      ('Overline · Inter Bold · 10', AppTypography.overline),
      ('Mono Large · JetBrains Mono · 16', AppTypography.monoLarge),
      ('Mono · JetBrains Mono · 13', AppTypography.mono),
      ('Mono Small · JetBrains Mono · 10', AppTypography.monoSmall),
    ];

    return StoryCanvas(
      children: [
        StorySection(
          title: 'Type scale',
          description: 'Display, interface, and numeric roles.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final style in styles)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(style.$1, style: AppTypography.monoSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Move with purpose.', style: style.$2),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpacingScale extends StatelessWidget {
  const _SpacingScale();

  static const spaces = <(String, double)>[
    ('xs', AppSpacing.xs),
    ('sm', AppSpacing.sm),
    ('md', AppSpacing.md),
    ('lg', AppSpacing.lg),
    ('xl', AppSpacing.xl),
    ('xxl', AppSpacing.xxl),
    ('xxxl', AppSpacing.xxxl),
    ('huge', AppSpacing.huge),
    ('huge2', AppSpacing.huge2),
    ('huge3', AppSpacing.huge3),
    ('huge4', AppSpacing.huge4),
  ];

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Spacing scale',
          description: 'A 4px base grid for layout rhythm.',
          child: Column(
            children: [
              for (final space in spaces)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppSpacing.huge3,
                        child: Text(space.$1, style: AppTypography.monoSmall),
                      ),
                      Container(
                        width: space.$2,
                        height: AppSpacing.lg,
                        decoration: const BoxDecoration(
                          color: AppColors.forgeFire,
                          borderRadius: AppBorderRadius.small,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text('${space.$2.toInt()} px',
                          style: AppTypography.caption),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
