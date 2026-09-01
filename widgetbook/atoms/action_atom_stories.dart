import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import '../story_canvas.dart';

List<WidgetbookNode> buildActionAtomStories() {
  return [
    WidgetbookComponent(
      name: 'FgButton',
      useCases: [
        WidgetbookUseCase(name: 'Playground', builder: _buttonPlayground),
        WidgetbookUseCase(
          name: 'Variants and states',
          builder: (_) => const _ButtonMatrix(),
        ),
        WidgetbookUseCase(
          name: 'Content stress',
          builder: (_) => const _ButtonContentStress(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgIconButton',
      useCases: [
        WidgetbookUseCase(
          name: 'Variants and sizes',
          builder: (_) => const _IconButtonMatrix(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgFilterChip',
      useCases: [
        WidgetbookUseCase(
          name: 'Selection states',
          builder: (_) => const _FilterChipStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgMenuButton',
      useCases: [
        WidgetbookUseCase(
          name: 'Selection',
          builder: (_) => const _MenuButtonStory(),
        ),
      ],
    ),
  ];
}

Widget _buttonPlayground(BuildContext context) {
  final text = context.knobs.string(
    label: 'Label',
    initialValue: 'Start training',
  );
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: FgButtonVariant.values,
    initialOption: FgButtonVariant.primary,
    labelBuilder: (value) => value.name,
  );
  final size = context.knobs.object.segmented(
    label: 'Size',
    options: FgButtonSize.values,
    initialOption: FgButtonSize.lg,
    labelBuilder: (value) => value.name.toUpperCase(),
  );
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final loading = context.knobs.boolean(label: 'Loading', initialValue: false);
  final expanded = context.knobs.boolean(label: 'Expand', initialValue: false);
  final shape = context.knobs.object.segmented(
    label: 'Shape',
    options: FgButtonShape.values,
    initialOption: FgButtonShape.pill,
    labelBuilder: (value) => value.name,
  );
  final showIcon = context.knobs.boolean(label: 'Leading icon');

  return StoryCanvas(
    children: [
      StorySection(
        title: 'Button playground',
        description:
            'Semantic variant, size, shape, content, and interaction state.',
        child: FgButton(
          text: text,
          variant: variant,
          shape: shape,
          size: size,
          isEnabled: enabled,
          isLoading: loading,
          expand: expanded,
          icon: showIcon ? const Icon(Icons.fitness_center_rounded) : null,
          onPressed: () {},
        ),
      ),
    ],
  );
}

class _ButtonMatrix extends StatelessWidget {
  const _ButtonMatrix();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        for (final variant in FgButtonVariant.values)
          StorySection(
            title: variant.name,
            child: Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                for (final size in FgButtonSize.values)
                  FgButton(
                    text: size.name.toUpperCase(),
                    variant: variant,
                    size: size,
                    onPressed: () {},
                  ),
                FgButton(
                  text: 'Disabled',
                  variant: variant,
                  isEnabled: false,
                  onPressed: () {},
                ),
                FgButton(
                  text: 'Loading',
                  variant: variant,
                  isLoading: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ButtonContentStress extends StatelessWidget {
  const _ButtonContentStress();

  @override
  Widget build(BuildContext context) {
    return const StoryCanvas(
      children: [
        StorySection(
          title: 'Content and target stress',
          description:
              'Long labels, mixed content, and icon-only actions retain a '
              'minimum 48px target.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 240,
                child: FgButton(
                  text: 'Continue to the next training movement',
                  expand: true,
                  onPressed: _noop,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              FgButton(
                text: 'Add movement',
                icon: Icon(Icons.add_rounded),
                variant: FgButtonVariant.secondary,
                onPressed: _noop,
              ),
              SizedBox(height: AppSpacing.lg),
              FgButton(
                icon: Icon(Icons.play_arrow_rounded),
                semanticLabel: 'Play movement',
                onPressed: _noop,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconButtonMatrix extends StatelessWidget {
  const _IconButtonMatrix();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        for (final variant in FgIconButtonVariant.values)
          StorySection(
            title: variant.name,
            child: Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                for (final size in FgIconButtonSize.values)
                  FgIconButton(
                    icon: Icons.play_arrow_rounded,
                    semanticLabel: 'Play ${size.name} action',
                    variant: variant,
                    size: size,
                    onPressed: () {},
                  ),
                FgIconButton(
                  icon: Icons.lock_outline_rounded,
                  semanticLabel: 'Locked action',
                  variant: variant,
                  isEnabled: false,
                  onPressed: () {},
                ),
                FgIconButton(
                  icon: Icons.sync_rounded,
                  semanticLabel: 'Sync action',
                  variant: variant,
                  isLoading: true,
                  onPressed: () {},
                ),
                FgIconButton(
                  icon: Icons.favorite_rounded,
                  semanticLabel: 'Selected favorite action',
                  variant: variant,
                  isSelected: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FilterChipStory extends StatefulWidget {
  const _FilterChipStory();

  @override
  State<_FilterChipStory> createState() => _FilterChipStoryState();
}

class _FilterChipStoryState extends State<_FilterChipStory> {
  final Set<String> _selected = {'Hip hop'};

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Interactive selection',
          description: 'Native selection, icons, and disabled-selected states.',
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final label in const ['Hip hop', 'House', 'Breaking'])
                FgFilterChip(
                  label: label,
                  isSelected: _selected.contains(label),
                  icon: Icons.music_note_rounded,
                  onSelected: (selected) {
                    setState(() {
                      selected ? _selected.add(label) : _selected.remove(label);
                    });
                  },
                ),
              const FgFilterChip(
                label: 'Locked selected',
                icon: Icons.lock_outline_rounded,
                isSelected: true,
                isEnabled: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _noop() {}

class _MenuButtonStory extends StatefulWidget {
  const _MenuButtonStory();

  @override
  State<_MenuButtonStory> createState() => _MenuButtonStoryState();
}

class _MenuButtonStoryState extends State<_MenuButtonStory> {
  int _columns = 2;

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Typed menu selection',
          child: FgMenuButton<int>(
            icon: Icons.grid_view_rounded,
            semanticLabel: 'Choose grid columns',
            items: [
              for (final columns in const [2, 3, 4])
                FgMenuItem(
                  value: columns,
                  label: '$columns columns',
                  isSelected: columns == _columns,
                ),
            ],
            onSelected: (value) => setState(() => _columns = value),
          ),
        ),
      ],
    );
  }
}
