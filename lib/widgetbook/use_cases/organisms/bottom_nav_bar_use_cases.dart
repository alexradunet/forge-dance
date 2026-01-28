import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../design_system/organisms/navigation/bottom_nav_bar.dart';
import '../../theme/app_colors.dart';

// TODO: Fix type resolution issue with widgetbook_generator
// @widgetbook.UseCase(
//   name: 'Default',
//   type: BottomNavBar,
//   path: 'Design System/Organisms',
// )
Widget buildBottomNavBarDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: const Center(
      child: Text(
        'Content',
        style: TextStyle(color: AppColors.crystalWhite),
      ),
    ),
    bottomNavigationBar: BottomNavBar(
      selectedIndex: 0,
      onTabSelected: (index) {},
    ),
  );
}
