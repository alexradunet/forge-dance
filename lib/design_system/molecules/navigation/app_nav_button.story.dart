import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/navigation/app_nav_button.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'App Nav Button',
  type: AppNavButton,
  path: 'Design System/Molecules/Navigation',
)
Widget buildAppNavButton(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppNavButton(
            icon: Icons.home,
            label: 'Home',
            isActive:
                context.knobs.boolean(label: 'Is Active', initialValue: true),
            onTap: () {},
          ),
          const SizedBox(width: 16),
          AppNavButton(
            icon: Icons.search,
            label: 'Explore',
            isActive: false,
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
