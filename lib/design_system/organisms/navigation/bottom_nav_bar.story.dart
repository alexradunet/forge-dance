import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/navigation/bottom_nav_bar.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: BottomNavBar,
  path: 'Design System/Organisms/Navigation',
)
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
