import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import '../story_canvas.dart';

List<WidgetbookNode> buildInputAtomStories() {
  return [
    WidgetbookComponent(
      name: 'FgInput',
      useCases: [
        WidgetbookUseCase(
          name: 'Variants and states',
          builder: (_) => const _InputStates(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgToggle',
      useCases: [
        WidgetbookUseCase(
          name: 'Interactive',
          builder: (_) => const _ToggleStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgRadioButton',
      useCases: [
        WidgetbookUseCase(
          name: 'States',
          builder: (_) => const _RadioStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgCheckboxItem',
      useCases: [
        WidgetbookUseCase(
          name: 'States',
          builder: (_) => const _CheckboxStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgSlider',
      useCases: [
        WidgetbookUseCase(
          name: 'Interactive',
          builder: (_) => const _SliderStory(),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'FgStepper',
      useCases: [
        WidgetbookUseCase(
          name: 'Interactive',
          builder: (_) => const _StepperStory(),
        ),
      ],
    ),
  ];
}

class _InputStates extends StatelessWidget {
  const _InputStates();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        const StorySection(
          title: 'Standard',
          child: FgInput(
            label: 'Email',
            placeholder: 'dancer@example.com',
            isRequired: true,
          ),
        ),
        StorySection(
          title: 'Password',
          child: FgInput.password(
            label: 'Password',
            placeholder: 'Enter password',
            helperText: 'Use at least 6 characters',
            isRequired: true,
            showPasswordSemanticsLabel: 'Show password',
            hidePasswordSemanticsLabel: 'Hide password',
          ),
        ),
        StorySection(
          title: 'Search',
          child: FgInput.search(
            placeholder: 'Search dance styles',
            showFilter: true,
            onFilterPressed: () {},
          ),
        ),
        const StorySection(
          title: 'Error',
          child: FgInput(
            label: 'Email',
            placeholder: 'dancer@example.com',
            errorText: 'Enter a valid email address',
          ),
        ),
        const StorySection(
          title: 'Disabled',
          child: FgInput(
            label: 'Email',
            placeholder: 'dancer@example.com',
            isEnabled: false,
          ),
        ),
      ],
    );
  }
}

class _ToggleStory extends StatefulWidget {
  const _ToggleStory();

  @override
  State<_ToggleStory> createState() => _ToggleStoryState();
}

class _ToggleStoryState extends State<_ToggleStory> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Interactive state',
          child: Wrap(
            spacing: AppSpacing.xxl,
            runSpacing: AppSpacing.lg,
            children: [
              FgToggle(
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
              ),
              const FgToggle(value: false, isEnabled: false),
              const FgToggle(value: true, isEnabled: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadioStory extends StatefulWidget {
  const _RadioStory();

  @override
  State<_RadioStory> createState() => _RadioStoryState();
}

class _RadioStoryState extends State<_RadioStory> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Selection states',
          child: Wrap(
            spacing: AppSpacing.xxl,
            runSpacing: AppSpacing.lg,
            children: [
              for (var index = 0; index < 3; index++)
                FgRadioButton(
                  isSelected: _selected == index,
                  onTap: () => setState(() => _selected = index),
                ),
              const FgRadioButton(isSelected: false, isEnabled: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckboxStory extends StatefulWidget {
  const _CheckboxStory();

  @override
  State<_CheckboxStory> createState() => _CheckboxStoryState();
}

class _CheckboxStoryState extends State<_CheckboxStory> {
  CheckboxState _state = CheckboxState.unchecked;

  void _advanceState() {
    final next = (_state.index + 1) % CheckboxState.values.length;
    setState(() => _state = CheckboxState.values[next]);
  }

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Tri-state control',
          description: 'Tap the first item to cycle all supported states.',
          child: Wrap(
            spacing: AppSpacing.xxl,
            runSpacing: AppSpacing.lg,
            children: [
              FgCheckboxItem(state: _state, onTap: _advanceState),
              const FgCheckboxItem(state: CheckboxState.checked),
              const FgCheckboxItem(state: CheckboxState.indeterminate),
              const FgCheckboxItem(
                state: CheckboxState.unchecked,
                isEnabled: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SliderStory extends StatefulWidget {
  const _SliderStory();

  @override
  State<_SliderStory> createState() => _SliderStoryState();
}

class _SliderStoryState extends State<_SliderStory> {
  double _value = 108;

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Tempo',
          child: FgSlider(
            value: _value,
            min: 60,
            max: 180,
            label: 'Practice tempo',
            valueLabel: '${_value.round()} BPM',
            showBpmStyle: true,
            showTicks: true,
            onChanged: (value) => setState(() => _value = value),
          ),
        ),
        const StorySection(
          title: 'Disabled',
          child: FgSlider(
            value: 72,
            min: 60,
            max: 180,
            label: 'Practice tempo',
            isEnabled: false,
          ),
        ),
      ],
    );
  }
}

class _StepperStory extends StatefulWidget {
  const _StepperStory();

  @override
  State<_StepperStory> createState() => _StepperStoryState();
}

class _StepperStoryState extends State<_StepperStory> {
  int _rounds = 4;

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Workout rounds',
          child: FgStepper(
            value: _rounds,
            min: 1,
            max: 10,
            label: 'Rounds',
            unit: 'sets',
            showBounds: true,
            onChanged: (value) => setState(() => _rounds = value),
          ),
        ),
        const StorySection(
          title: 'Disabled',
          child: FgStepper(
            value: 4,
            min: 1,
            max: 10,
            label: 'Rounds',
            isEnabled: false,
          ),
        ),
      ],
    );
  }
}
