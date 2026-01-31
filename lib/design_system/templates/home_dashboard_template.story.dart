import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/templates/home_dashboard_template.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Home Dashboard Template',
  type: HomeDashboardTemplate,
  path: 'Design System/Templates',
)
Widget buildHomeDashboardTemplate(BuildContext context) {
  return HomeDashboardTemplate(
    header: Container(
      height: 60,
      color: AppColors.gray800,
      child: const Center(
          child: Text('Header', style: TextStyle(color: Colors.white))),
    ),
    featuredContent: Container(
      height: 200,
      color: AppColors.gray800,
      child: const Center(
          child:
              Text('Featured Content', style: TextStyle(color: Colors.white))),
    ),
    progressSection: Container(
      height: 100,
      color: AppColors.gray800,
      child: const Center(
          child:
              Text('Progress Section', style: TextStyle(color: Colors.white))),
    ),
    quickActions: Container(
      height: 80,
      color: AppColors.gray800,
      child: const Center(
          child: Text('Quick Actions', style: TextStyle(color: Colors.white))),
    ),
    bottomNavigation: Container(
      height: 60,
      color: AppColors.gray900,
      child: const Center(
          child:
              Text('Bottom Navigation', style: TextStyle(color: Colors.white))),
    ),
  );
}
