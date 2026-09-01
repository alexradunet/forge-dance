import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import '../story_canvas.dart';

List<WidgetbookNode> buildInputAtomStories() {
  return [
    WidgetbookComponent(
      name: 'FgInput',
      useCases: [
        WidgetbookUseCase(name: 'Playground', builder: _inputPlayground),
        WidgetbookUseCase(
          name: 'Variants and states',
          builder: (_) => const _InputStates(),
        ),
        WidgetbookUseCase(
          name: 'Content stress',
          builder: (_) => const _InputContentStress(),
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

Widget _inputPlayground(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Email');
  final placeholder = context.knobs.string(
    label: 'Placeholder',
    initialValue: 'dancer@example.com',
  );
  final helper = context.knobs.string(
    label: 'Helper',
    initialValue: 'Used for account recovery',
  );
  final error = context.knobs.string(label: 'Error');
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final readOnly = context.knobs.boolean(label: 'Read only');
  final required = context.knobs.boolean(label: 'Required');
  final loading = context.knobs.boolean(label: 'Loading');

  return StoryCanvas(
    children: [
      StorySection(
        title: 'Input playground',
        description:
            'Theme-owned field appearance with semantic state and copy.',
        child: FgInput(
          label: label,
          placeholder: placeholder,
          helperText: helper.isEmpty ? null : helper,
          errorText: error.isEmpty ? null : error,
          isEnabled: enabled,
          readOnly: readOnly,
          isRequired: required,
          isLoading: loading,
          loadingSemanticsLabel: loading ? 'Loading field' : null,
        ),
      ),
    ],
  );
}

class _InputStates extends StatefulWidget {
  const _InputStates();

  @override
  State<_InputStates> createState() => _InputStatesState();
}

class _InputStatesState extends State<_InputStates> {
  final _emailController = TextEditingController(text: 'dancer@example.com');
  final _searchController = TextEditingController(text: 'House');

  @override
  void dispose() {
    _emailController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        StorySection(
          title: 'Filled',
          child: FgInput(
            label: 'Email',
            controller: _emailController,
            prefixIcon: Icons.mail_outline_rounded,
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
          title: 'Search actions',
          child: FgInput.search(
            placeholder: 'Search dance styles',
            controller: _searchController,
            onClear: () {},
            clearSemanticsLabel: 'Clear search',
            showFilter: true,
            onFilterPressed: () {},
            filterSemanticsLabel: 'Filter search',
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
        StorySection(
          title: 'Read only',
          child: FgInput(
            label: 'Email',
            controller: _emailController,
            readOnly: true,
          ),
        ),
        const StorySection(
          title: 'Loading',
          child: FgInput(
            label: 'Email',
            isLoading: true,
            loadingSemanticsLabel: 'Loading email',
          ),
        ),
      ],
    );
  }
}

class _InputContentStress extends StatelessWidget {
  const _InputContentStress();

  @override
  Widget build(BuildContext context) {
    return StoryCanvas(
      children: [
        const StorySection(
          title: 'Long copy',
          description:
              'Long labels, helpers, and errors remain readable at large text '
              'scales.',
          child: FgInput(
            label: 'Preferred email address for training notifications',
            helperText:
                'We use this address for recovery and important changes to '
                'your training plan.',
            isRequired: true,
          ),
        ),
        StorySection(
          title: 'Multiline',
          child: FgInput.multiline(
            label: 'Training notes',
            placeholder: 'Describe what you want to improve',
            helperText: 'Include movement names, tempo, and current blockers.',
          ),
        ),
        const StorySection(
          title: 'Long error',
          child: FgInput(
            label: 'Email',
            errorText:
                'Enter a complete email address including the domain, such as '
                'dancer@example.com.',
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
                semanticLabel: 'Enable practice reminders',
                onChanged: (value) => setState(() => _enabled = value),
              ),
              const FgToggle(
                value: false,
                semanticLabel: 'Disabled off toggle',
                isEnabled: false,
              ),
              const FgToggle(
                value: true,
                semanticLabel: 'Disabled on toggle',
                isEnabled: false,
              ),
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
  FgCheckboxState _state = FgCheckboxState.unchecked;

  void _advanceState() {
    final next = (_state.index + 1) % FgCheckboxState.values.length;
    setState(() => _state = FgCheckboxState.values[next]);
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
              FgCheckboxItem(
                state: _state,
                semanticLabel: 'Cycle tri-state option',
                onTap: _advanceState,
              ),
              const FgCheckboxItem(
                state: FgCheckboxState.checked,
                semanticLabel: 'Checked option',
              ),
              const FgCheckboxItem(
                state: FgCheckboxState.indeterminate,
                semanticLabel: 'Mixed option',
              ),
              const FgCheckboxItem(
                state: FgCheckboxState.unchecked,
                semanticLabel: 'Disabled option',
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
            semanticLabel: 'Practice tempo',
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
            semanticLabel: 'Disabled practice tempo',
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
            decrementSemanticsLabel: 'Decrease workout rounds',
            incrementSemanticsLabel: 'Increase workout rounds',
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
            decrementSemanticsLabel: 'Decrease workout rounds',
            incrementSemanticsLabel: 'Increase workout rounds',
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
