import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/modals/fg_filter_sheet.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgFilterSheet,
  path: 'Design System/Organisms/Modals',
)
Widget buildFgFilterSheetPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: FgFilterSheet(
        sections: {
          'Difficulty': ['Beginner', 'Intermediate', 'Advanced', 'Expert'],
          'Style': ['Urban', 'Contemporary', 'Hip Hop', 'Jazz'],
          'Type': ['Theory', 'Drill', 'Movement', 'Boss'],
        },
        selectedFilters: {
          'Difficulty': context.knobs.list(
            label: 'Selected Difficulty',
            options: ['Beginner', 'Intermediate', 'Advanced', 'Expert'],
            initialOption: 'Intermediate',
          ),
          'Style': context.knobs.list(
            label: 'Selected Style',
            options: ['Urban', 'Contemporary', 'Hip Hop', 'Jazz'],
            initialOption: 'Urban',
          ),
        },
        onFilterSelected: (section, value) {},
        onReset: () {},
        onApply: () {},
      ),
    ),
  );
}
