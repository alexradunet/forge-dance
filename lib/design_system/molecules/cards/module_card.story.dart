import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Type X (2:3)',
  type: ModuleCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildModuleCardTypeX(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 200,
          child: ModuleCard(
            title: 'Hip Hop Basics',
            subtitle: 'Level 1',
            type: ModuleCardType.x,
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Type XX (2:1)',
  type: ModuleCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildModuleCardTypeXX(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 200,
          child: ModuleCard(
            title: 'Advanced Moves',
            subtitle: 'Level 5',
            type: ModuleCardType.xx,
          ),
        ),
      ),
    ),
  );
}
