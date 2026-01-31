import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/controls/bpm_widget.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'BPM Widget',
  type: BPMWidget,
  path: 'Design System/Molecules/Controls',
)
Widget buildBPMWidget(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BPMWidget(
          initialBPM: context.knobs.int.slider(
              label: 'Initial BPM', initialValue: 128, min: 60, max: 200),
          minBPM: context.knobs.int.input(label: 'Min BPM', initialValue: 60),
          maxBPM: context.knobs.int.input(label: 'Max BPM', initialValue: 200),
          onBPMChanged: (value) {},
        ),
      ),
    ),
  );
}
