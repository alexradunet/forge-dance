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
  final enabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
  );
  final loading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );
  final expanded = context.knobs.boolean(
    label: 'Expand',
    initialValue: false,
  );

  return StoryCanvas(
    children: [
      StorySection(
        title: 'Button playground',
        description: 'Semantic props only: variant, size, and state.',
        child: FgButton(
          text: text,
          variant: variant,
          size: size,
          isEnabled: enabled,
          isLoading: loading,
          expand: expanded,
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
                    variant: variant,
                    size: size,
                    onPressed: () {},
                  ),
                FgIconButton(
                  icon: Icons.lock_outline_rounded,
                  variant: variant,
                  isEnabled: false,
                  onPressed: () {},
                ),
                FgIconButton(
                  icon: Icons.sync_rounded,
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
          description: 'Chips expose selected and disabled states.',
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final label in const ['Hip hop', 'House', 'Breaking'])
                FgFilterChip(
                  label: label,
                  isSelected: _selected.contains(label),
                  onSelected: (selected) {
                    setState(() {
                      selected ? _selected.add(label) : _selected.remove(label);
                    });
                  },
                ),
              const FgFilterChip(
                label: 'Locked',
                isSelected: false,
                isEnabled: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
