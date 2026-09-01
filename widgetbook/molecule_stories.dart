import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import 'story_canvas.dart';

const _danceImage =
    'https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&q=80';

List<WidgetbookNode> buildMoleculeStories() {
  return [
    WidgetbookCategory(
      name: 'Cards',
      children: [
        _component('FgContentCard', (_) => const _ContentCardStory()),
        _component('FgInteractiveCard', (_) => const _InteractiveCardStory()),
        _component(
          'FgInteractiveCardThumbnail',
          (_) => const _InteractiveCardThumbnailStory(),
        ),
      ],
    ),
    WidgetbookCategory(
      name: 'Inputs',
      children: [
        _component('FgCheckboxGroup', (_) => const _CheckboxGroupStory()),
        _component('FgRadioGroup', (_) => const _RadioGroupStory()),
      ],
    ),
    WidgetbookCategory(
      name: 'Feedback',
      children: [
        _component('FgEmpty', (_) => const _EmptyStory()),
        _component('FgSnackBar', (_) => const _SnackBarStory()),
      ],
    ),
    WidgetbookCategory(
      name: 'Navigation',
      children: [_component('FgNavButton', (_) => const _NavButtonStory())],
    ),
    WidgetbookCategory(
      name: 'Lessons',
      children: [_component('Lesson nodes', (_) => const _LessonNodeStory())],
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

class _ContentCardStory extends StatelessWidget {
  const _ContentCardStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Standard',
          child: Align(
            alignment: Alignment.centerLeft,
            child: FgContentCard(
              width: 320,
              title: 'Groove foundations',
              subtitle: 'Build timing, bounce, and confidence.',
              imageUrl: _danceImage,
              tags: const ['Beginner', 'Hip hop'],
              rating: 4.8,
              duration: '18 min',
              progress: 0.65,
              footerLabel: 'Continue',
              onTap: () {},
            ),
          ),
        ),
        StorySection(
          title: 'Compact',
          child: Align(
            alignment: Alignment.centerLeft,
            child: FgContentCard.compact(
              width: 280,
              title: 'Top rock basics',
              subtitle: 'Breaking',
              imageUrl: _danceImage,
              progress: 0.3,
              duration: '12 min',
              onTap: () {},
            ),
          ),
        ),
        StorySection(
          title: 'Hero',
          child: FgContentCard.hero(
            title: 'Train with intent',
            subtitle: 'Today’s featured session',
            imageUrl: _danceImage,
            tags: const ['Featured', '25 min'],
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _InteractiveCardStory extends StatelessWidget {
  const _InteractiveCardStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Flip card',
          description: 'Use the labeled controls to inspect every state.',
          child: Align(
            child: SizedBox(
              width: 320,
              height: 560,
              child: FgInteractiveCard(
                title: 'Body control',
                flipSemanticLabel: 'Flip lesson card',
                playSemanticLabel: 'Play lesson',
                favoriteSemanticLabel: 'Favorite lesson',
                subtitle: 'Lesson 3 of 8',
                backgroundImage: _danceImage,
                tags: const ['Control', 'Foundations'],
                level: 'Level 2',
                style: 'Hip hop',
                difficulty: 'Beginner',
                progress: 0.38,
                backTitle: 'Training focus',
                backSubtitle: 'Isolation, posture, and clean transitions.',
                onPlayTap: () {},
                onToggleFavorite: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InteractiveCardThumbnailStory extends StatelessWidget {
  const _InteractiveCardThumbnailStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Collection thumbnail',
          child: Align(
            child: SizedBox(
              width: 240,
              height: 360,
              child: FgInteractiveCardThumbnail(
                title: 'Groove theory',
                flipSemanticLabel: 'Flip lesson card',
                subtitle: 'Foundations',
                backgroundImage: _danceImage,
                level: 'In progress',
                backTitle: 'Resume lesson',
                backSubtitle: '6 minutes remaining',
                onTap: (_) {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckboxGroupStory extends StatefulWidget {
  const _CheckboxGroupStory();

  @override
  State<_CheckboxGroupStory> createState() => _CheckboxGroupStoryState();
}

class _CheckboxGroupStoryState extends State<_CheckboxGroupStory> {
  Set<String> _selected = {'musicality'};

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Training goals',
          child: FgCheckboxGroup(
            semanticLabel: 'Training goals',
            items: [
              for (final option in const [
                ('musicality', 'Improve musicality'),
                ('conditioning', 'Build conditioning'),
                ('freestyle', 'Practice freestyle'),
              ])
                FgCheckboxGroupItem(
                  id: option.$1,
                  label: option.$2,
                  value: _selected.contains(option.$1),
                ),
            ],
            onChanged: (values) => setState(() => _selected = values.toSet()),
          ),
        ),
      ],
    );
  }
}

class _RadioGroupStory extends StatefulWidget {
  const _RadioGroupStory();

  @override
  State<_RadioGroupStory> createState() => _RadioGroupStoryState();
}

class _RadioGroupStoryState extends State<_RadioGroupStory> {
  String _selected = 'beginner';

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Experience level',
          child: FgRadioGroup<String>(
            semanticLabel: 'Experience level',
            items: [
              FgRadioGroupItem(label: 'Beginner', value: 'beginner'),
              FgRadioGroupItem(label: 'Intermediate', value: 'intermediate'),
              FgRadioGroupItem(label: 'Advanced', value: 'advanced'),
            ],
            selectedValue: _selected,
            onChanged: (value) => setState(() => _selected = value),
          ),
        ),
      ],
    );
  }
}

class _EmptyStory extends StatelessWidget {
  const _EmptyStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'No saved sessions',
          child: FgEmpty(
            icon: Icons.bookmark_border_rounded,
            title: 'Nothing saved yet',
            description: 'Save lessons and workouts to find them here.',
            actionLabel: 'Explore training',
            onAction: () {},
          ),
        ),
      ],
    );
  }
}

class _SnackBarStory extends StatelessWidget {
  const _SnackBarStory();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Semantic tones',
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final tone in FgSnackBarTone.values)
                FgButton(
                  text: tone.name,
                  variant: tone == FgSnackBarTone.error
                      ? FgButtonVariant.destructive
                      : FgButtonVariant.secondary,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    FgSnackBar.build(
                      context,
                      text: '${tone.name} feedback message',
                      tone: tone,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavButtonStory extends StatefulWidget {
  const _NavButtonStory();

  @override
  State<_NavButtonStory> createState() => _NavButtonStoryState();
}

class _NavButtonStoryState extends State<_NavButtonStory> {
  int _selected = 1;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_outlined, 'Home'),
      (Icons.school_outlined, 'Learn'),
      (Icons.fitness_center_rounded, 'Workout'),
    ];

    return StoryCanvas(
      children: [
        StorySection(
          title: 'Navigation states',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var index = 0; index < items.length; index++)
                FgNavButton(
                  icon: items[index].$1,
                  label: items[index].$2,
                  isActive: _selected == index,
                  onTap: () => setState(() => _selected = index),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LessonNodeStory extends StatelessWidget {
  const _LessonNodeStory();

  @override
  Widget build(BuildContext context) {
    const theory = LessonNode(
      title: 'Understand the groove',
      type: LessonNodeType.theory,
      state: LessonNodeState.completed,
      duration: '6 min',
      progress: 1,
    );
    const movement = LessonNode(
      title: 'Practice the bounce',
      type: LessonNodeType.movement,
      state: LessonNodeState.current,
      duration: '12 min',
      progress: 0.45,
    );
    const boss = LessonNode(
      title: 'Foundation challenge',
      type: LessonNodeType.boss,
      state: LessonNodeState.locked,
      duration: '20 min',
    );

    return StoryCanvas(
      children: [
        const StorySection(
          title: 'Standard node',
          child: FgLessonTimelineStandardNode(node: theory),
        ),
        StorySection(
          title: 'Movement card',
          child: FgLessonTimelineMovementCard(
            node: movement,
            onNavigate: (_) {},
          ),
        ),
        const StorySection(
          title: 'Boss node',
          child: FgLessonTimelineBossNode(node: boss),
        ),
      ],
    );
  }
}
