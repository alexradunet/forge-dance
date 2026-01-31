import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Streak',
  type: StatCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildStatCardStreak(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: StatCard(
          label: 'STREAK',
          value: '7',
          unit: 'days',
          icon: '🔥',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Level',
  type: StatCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildStatCardLevel(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: StatCard(
          label: 'LEVEL',
          value: '5',
          icon: '⭐',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'XP',
  type: StatCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildStatCardXP(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: StatCard(
          label: 'XP',
          value: '1,250',
          icon: '⚡',
        ),
      ),
    ),
  );
}
