import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: ExerciseCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildExerciseCardDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 200,
          child: ExerciseCard(
            title: 'Chest Pops',
            style: 'Hip Hop',
            level: 3,
            duration: '45 seconds',
          ),
        ),
      ),
    ),
  );
}
