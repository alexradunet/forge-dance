import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppSpacing,
  path: 'Design System/Tokens',
)
Widget buildSpacingShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _SpacingRow(name: 'XS (4px)', size: AppSpacing.xs),
        _SpacingRow(name: 'SM (8px)', size: AppSpacing.sm),
        _SpacingRow(name: 'MD (12px)', size: AppSpacing.md),
        _SpacingRow(name: 'LG (16px)', size: AppSpacing.lg),
        _SpacingRow(name: 'XL (20px)', size: AppSpacing.xl),
        _SpacingRow(name: 'XXL (24px)', size: AppSpacing.xxl),
        _SpacingRow(name: 'XXXL (32px)', size: AppSpacing.xxxl),
        _SpacingRow(name: 'Huge (40px)', size: AppSpacing.huge),
        _SpacingRow(name: 'Huge 2 (48px)', size: AppSpacing.huge2),
        _SpacingRow(name: 'Huge 3 (64px)', size: AppSpacing.huge3),
        _SpacingRow(name: 'Huge 4 (80px)', size: AppSpacing.huge4),
      ],
    ),
  );
}

class _SpacingRow extends StatelessWidget {
  final String name;
  final double size;

  const _SpacingRow({required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(name,
                style: AppTypography.bodySmall.copyWith(color: Colors.white)),
          ),
          Container(
            width: size,
            height: 24,
            color: AppColors.latinRose,
          ),
          const SizedBox(width: 8),
          Container(
            width: 24,
            height: 24,
            color: AppColors.gray800,
          )
        ],
      ),
    );
  }
}
