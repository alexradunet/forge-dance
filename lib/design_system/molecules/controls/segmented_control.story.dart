import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/controls/segmented_control.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Segmented Control',
  type: SegmentedControl,
  path: 'Design System/Molecules/Controls',
)
Widget buildSegmentedControl(BuildContext context) {
  final options = ['Option 1', 'Option 2', 'Option 3'];
  String selected = options[0];

  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(builder: (context, setState) {
          return SegmentedControl<String>(
            options: options,
            selectedValue: selected,
            onSelectionChanged: (value) {
              setState(() => selected = value);
            },
          );
        }),
      ),
    ),
  );
}
