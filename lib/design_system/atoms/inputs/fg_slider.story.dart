import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgSlider,
  path: 'Design System/Atoms/Inputs',
)
Widget buildSliderPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: FgSlider(
          value: context.knobs.double
              .slider(label: 'Value', initialValue: 50, min: 0, max: 100),
          isEnabled:
              context.knobs.boolean(label: 'Enabled', initialValue: true),
          showBpmStyle:
              context.knobs.boolean(label: 'BPM Style', initialValue: false),
          onChanged: (_) {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgSlider,
  path: 'Design System/Atoms/Inputs',
)
Widget buildSliderShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _SliderSection(
            title: 'Standard',
            child: FgSlider(
              value: 0.6,
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: 48),
          _SliderSection(
            title: 'BPM Style',
            child: FgSlider(
              value: 120,
              min: 60,
              max: 180,
              showBpmStyle: true,
              valueLabel: '120 BPM',
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: 48),
          _SliderSection(
            title: 'Disabled',
            child: FgSlider(
              value: 0.4,
              isEnabled: false,
              onChanged: null,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SliderSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SliderSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.h5.copyWith(color: Colors.white)),
        const SizedBox(height: 24),
        child,
      ],
    );
  }
}
