import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Bottom Sheet',
  type: ForgeBottomSheet,
  path: 'Design System/Organisms',
)
Widget buildForgeBottomSheet(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: ElevatedButton(
        onPressed: () {
          ForgeBottomSheet.show(
            context: context,
            title: 'Filters',
            resetLabel: 'Reset',
            actionLabel: 'Apply Filters',
            child: Column(
              children: [
                ToggleListItem(
                  title: 'Show Completed',
                  value: true,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 8),
                ToggleListItem(
                  title: 'High Intensity Only',
                  value: false,
                  onChanged: (_) {},
                ),
              ],
            ),
          );
        },
        child: const Text('Show Bottom Sheet'),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Action Sheet',
  type: ForgeActionSheet,
  path: 'Design System/Organisms',
)
Widget buildForgeActionSheet(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: ElevatedButton(
        onPressed: () {
          ForgeActionSheet.show(
            context: context,
            title: 'Workout Options',
            actions: [
              ForgeActionSheetItem(
                label: 'Share Activity',
                icon: Icons.ios_share,
                onTap: () {},
              ),
              ForgeActionSheetItem(
                label: 'Add to Favorites',
                icon: Icons.favorite,
                onTap: () {},
              ),
              ForgeActionSheetItem(
                label: 'Report Issue',
                icon: Icons.flag,
                color: AppColors.crystalWhite,
                onTap: () {},
              ),
            ],
          );
        },
        child: const Text('Show Action Sheet'),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Alert Dialog',
  type: ForgeAlertDialog,
  path: 'Design System/Organisms',
)
Widget buildForgeAlertDialog(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: ElevatedButton(
        onPressed: () {
          ForgeAlertDialog.show(
            context: context,
            title: 'Quit Workout?',
            message:
                "You're on a 5-day streak! If you quit now, you'll lose your progress for this session.",
            icon: Icons.local_fire_department,
            primaryActionLabel: 'Quit Workout',
            secondaryActionLabel: 'Resume',
            isPrimaryDestructive: true,
          );
        },
        child: const Text('Show Alert'),
      ),
    ),
  );
}
