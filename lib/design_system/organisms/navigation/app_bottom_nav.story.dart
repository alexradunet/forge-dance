import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/navigation/app_bottom_nav.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: AppBottomNav,
  path: 'Design System/Organisms/Navigation',
)
Widget buildAppBottomNavDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    bottomNavigationBar: AppBottomNav(
      currentIndex: context.knobs.int
          .slider(label: 'Active Tab', initialValue: 2, min: 0, max: 4),
      onTabChange: (_) {},
    ),
    body: const Center(
      child: Text('Page Content', style: TextStyle(color: Colors.white)),
    ),
  );
}
