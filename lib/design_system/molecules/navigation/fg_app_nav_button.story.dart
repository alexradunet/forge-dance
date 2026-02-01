import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/navigation/fg_app_nav_button.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgNavButton,
  path: 'Design System/Molecules/Navigation',
)
Widget buildAppNavButtonPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgNavButton(
        icon: context.knobs.list(
          label: 'Icon',
          options: [Icons.home, Icons.search, Icons.menu, Icons.person],
          initialOption: Icons.home,
        ),
        label: context.knobs.string(label: 'Label', initialValue: 'Home'),
        isActive: context.knobs.boolean(label: 'Is Active', initialValue: true),
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgNavButton,
  path: 'Design System/Molecules/Navigation',
)
Widget buildAppNavButtonShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FgNavButton(
            icon: Icons.home,
            label: 'Active',
            isActive: true,
            onTap: () {},
          ),
          const SizedBox(width: 32),
          FgNavButton(
            icon: Icons.search,
            label: 'Inactive',
            isActive: false,
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
