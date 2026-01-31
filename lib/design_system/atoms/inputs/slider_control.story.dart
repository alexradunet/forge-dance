import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: SliderControl,
  path: 'Design System/Atoms/Inputs',
)
Widget buildSliderControlDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SliderControl(
          value: 0.6,
          onChanged: (_) {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'BPM Style',
  type: SliderControl,
  path: 'Design System/Atoms/Inputs',
)
Widget buildSliderControlBpm(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SliderControl(
          value: 120,
          min: 60,
          max: 180,
          showBpmStyle: true,
          valueLabel: '120 BPM',
          onChanged: (_) {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: SliderControl,
  path: 'Design System/Atoms/Inputs',
)
Widget buildSliderControlDisabled(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SliderControl(
          value: 0.4,
          isEnabled: false,
          onChanged: null,
        ),
      ),
    ),
  );
}
