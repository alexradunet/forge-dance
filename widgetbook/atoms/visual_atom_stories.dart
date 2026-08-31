import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import '../story_canvas.dart';

const _danceImage =
    'https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&q=80';

List<WidgetbookNode> buildVisualAtomStories() {
  return [
    _component('FgCard', (_) => const _CardStory()),
    _component('FgLabel', (_) => const _LabelStory()),
    _component('FgIcon', (_) => const _IconStory()),
    _component('FgIconLabel', (_) => const _IconLabelStory()),
    _component('FgDivider', (_) => const _DividerStory()),
    _component('FgRating', (_) => const _RatingStory()),
    _component('FgImage', (_) => const _ImageStory()),
    _component('FgShimmer', (_) => const _ShimmerStory()),
    _component('FgGlassContainer', (_) => const _GlassStory()),
    _component('FgBackground', (_) => const _BackgroundStory()),
    _component('FgGradientOverlay', (_) => const _GradientStory()),
    _component('FgAspectRatio', (_) => const _AspectRatioStory()),
    _component('FgTooltip', (_) => const _TooltipStory()),
    _component('FgLessonTimelineTrack', (_) => const _TimelineTrackStory()),
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

class _CardStory extends StatelessWidget {
  const _CardStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        for (final variant in FgCardVariant.values)
          StorySection(
            title: variant.name,
            child: FgCard(
              variant: variant,
              padding: AppSpacing.allLG,
              onTap: () {},
              child: Text(
                'Reusable surface content',
                style: AppTypography.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _IconLabelStory extends StatelessWidget {
  const _IconLabelStory();

  @override
  Widget build(BuildContext context) {
    return const StoryCanvas(
      children: [
        StorySection(
          title: 'Labeled metrics',
          child: Wrap(
            spacing: AppSpacing.xxxl,
            runSpacing: AppSpacing.lg,
            children: [
              FgIconLabel(
                icon: Icons.timer_outlined,
                label: 'Duration',
                value: '18 min',
              ),
              FgIconLabel(
                icon: Icons.bolt_rounded,
                label: 'Intensity',
                value: 'Medium',
                iconColor: AppColors.legendGold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LabelStory extends StatelessWidget {
  const _LabelStory();

  @override
  Widget build(BuildContext context) {
    return const StoryCanvas(
      children: [
        StorySection(
          title: 'Label states',
          child: Wrap(
            spacing: AppSpacing.xxxl,
            runSpacing: AppSpacing.lg,
            children: [
              FgLabel(text: 'Email'),
              FgLabel(text: 'Password', isRequired: true),
              FgLabel(text: 'Tempo', icon: Icons.music_note_rounded),
              FgLabel(text: 'Focused', tone: FgLabelTone.accent),
              FgLabel(text: 'Invalid', tone: FgLabelTone.error),
              FgLabel(text: 'Unavailable', tone: FgLabelTone.disabled),
              SizedBox(
                width: 220,
                child: FgLabel(
                  text: 'Preferred training notification address',
                  isRequired: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconStory extends StatelessWidget {
  const _IconStory();

  @override
  Widget build(BuildContext context) {
    return const StoryCanvas(
      children: [
        StorySection(
          title: 'Semantic sizes',
          child: Wrap(
            spacing: AppSpacing.xxxl,
            runSpacing: AppSpacing.lg,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FgIcon(icon: Icons.local_fire_department_outlined, size: 16),
              FgIcon(icon: Icons.local_fire_department_outlined),
              FgIcon(
                icon: Icons.local_fire_department_rounded,
                size: 40,
                color: AppColors.forgeFire,
                filled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DividerStory extends StatelessWidget {
  const _DividerStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        const StorySection(title: 'Horizontal', child: FgDivider.horizontal()),
        StorySection(
          title: 'Vertical',
          child: SizedBox(
            height: AppSizes.avatarLg,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: FgDivider.vertical(),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingStory extends StatefulWidget {
  const _RatingStory();

  @override
  State<_RatingStory> createState() => _RatingStoryState();
}

class _RatingStoryState extends State<_RatingStory> {
  double _rating = 3;

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Interactive rating',
          child: FgRating(
            value: _rating,
            onChanged: (value) => setState(() => _rating = value),
          ),
        ),
        const StorySection(
          title: 'Read only',
          child: FgRating(value: 4.5, itemSize: 32),
        ),
      ],
    );
  }
}

class _ImageStory extends StatelessWidget {
  const _ImageStory();

  @override
  Widget build(BuildContext context) {
    return const StoryCanvas(
      children: [
        StorySection(
          title: 'Remote image',
          child: FgImage(
            imageUrl: _danceImage,
            aspectRatio: 16 / 9,
            borderRadius: AppBorderRadius.medium,
          ),
        ),
      ],
    );
  }
}

class _ShimmerStory extends StatelessWidget {
  const _ShimmerStory();

  @override
  Widget build(BuildContext context) {
    return const StoryCanvas(
      children: [
        StorySection(
          title: 'Loading placeholders',
          child: Wrap(
            spacing: AppSpacing.xxl,
            runSpacing: AppSpacing.xxl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FgShimmer(width: 220, height: 20),
              FgShimmer(width: 220, height: 96),
              FgShimmer(width: 56, height: 56, shape: CircleBorder()),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassStory extends StatelessWidget {
  const _GlassStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Glass surface',
          child: FgGlassContainer(
            padding: AppSpacing.allLG,
            child: Text(
              'Layered content remains legible.',
              style: AppTypography.body.copyWith(color: AppColors.crystalWhite),
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundStory extends StatelessWidget {
  const _BackgroundStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Default gradients',
          child: SizedBox(
            height: 280,
            child: FgBackground(
              showGrid: true,
              child: Center(
                child: Text(
                  'FORGE.DANCE',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.crystalWhite,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientStory extends StatelessWidget {
  const _GradientStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Content scrim',
          child: FgAspectRatio(
            ratio: 16 / 9,
            child: FgGradientOverlay(
              colors: [Colors.transparent, AppColors.bgDeep],
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: AppSpacing.allLG,
                  child: Text('Readable overlay', style: AppTypography.h4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AspectRatioStory extends StatelessWidget {
  const _AspectRatioStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: '16:9 media frame',
          child: FgAspectRatio(
            ratio: 16 / 9,
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(
                child: FgIcon(icon: Icons.play_arrow_rounded),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TooltipStory extends StatelessWidget {
  const _TooltipStory();

  @override
  Widget build(BuildContext context) {
    return const StoryCanvas(
      children: [
        StorySection(
          title: 'Hover or long press',
          child: Align(
            alignment: Alignment.centerLeft,
            child: FgTooltip(
              message: 'Start this training session',
              child: FgIcon(icon: Icons.info_outline_rounded, size: 32),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineTrackStory extends StatelessWidget {
  const _TimelineTrackStory();

  @override
  Widget build(BuildContext context) {
    return const StoryCanvas(
      children: [
        StorySection(
          title: 'Vertical progression track',
          child: SizedBox(
            height: 280,
            child: Center(child: FgLessonTimelineTrack()),
          ),
        ),
      ],
    );
  }
}
