import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/atoms/fg_icon.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgIcon,
  path: 'Design System/Atoms',
)
Widget buildFgIconPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgIcon(
        icon: context.knobs.list(
          label: 'Icon',
          options: [
            Icons.home,
            Icons.star,
            Icons.settings,
            Icons.favorite,
            Icons.person,
          ],
          initialOption: Icons.home,
        ),
        size: context.knobs.double
            .slider(label: 'Size', initialValue: 24, min: 16, max: 64),
        color: context.knobs.color(
          label: 'Color',
          initialValue: AppColors.crystalWhite,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgIcon,
  path: 'Design System/Atoms',
)
Widget buildFgIconShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        children: [
          _IconVariant(icon: Icons.home, label: 'Home'),
          _IconVariant(
              icon: Icons.star, label: 'Star', color: AppColors.forgeFire),
          _IconVariant(
              icon: Icons.settings,
              label: 'Settings',
              color: AppColors.textMuted),
          _IconVariant(
              icon: Icons.favorite,
              label: 'Favorite',
              color: AppColors.passionRed),
          _IconVariant(
              icon: Icons.check_circle,
              label: 'Success',
              color: AppColors.growthGreen),
        ],
      ),
    ),
  );
}

class _IconVariant extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _IconVariant({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FgIcon(icon: icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}
