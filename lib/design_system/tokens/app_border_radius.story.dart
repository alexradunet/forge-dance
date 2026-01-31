import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppBorderRadius,
  path: 'Design System/Tokens',
)
Widget buildBorderRadiusPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.forgeFire,
          borderRadius: BorderRadius.circular(
            context.knobs.double
                .slider(label: 'Radius', initialValue: 8, min: 0, max: 75),
          ),
        ),
        child: Center(
          child: Text(
            'Radius',
            style: AppTypography.h6.copyWith(color: AppColors.crystalWhite),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppBorderRadius,
  path: 'Design System/Tokens',
)
Widget buildBorderRadiusShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(24),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _RadiusBox(name: 'Small (4px)', radius: AppBorderRadius.small),
        _RadiusBox(name: 'Medium (8px)', radius: AppBorderRadius.medium),
        _RadiusBox(name: 'Large (12px)', radius: AppBorderRadius.large),
        _RadiusBox(
            name: 'Extra Large (16px)', radius: AppBorderRadius.extraLarge),
        _RadiusBox(name: '2XL (24px)', radius: AppBorderRadius.xxLarge),
        _RadiusBox(name: '3XL (32px)', radius: AppBorderRadius.xxxLarge),
        _RadiusBox(name: 'Pill', radius: AppBorderRadius.pill),
        _RadiusBox(name: 'Circle', radius: AppBorderRadius.circle),
      ],
    ),
  );
}

class _RadiusBox extends StatelessWidget {
  final String name;
  final BorderRadius radius;

  const _RadiusBox({required this.name, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: radius,
        border: Border.all(color: AppColors.gray700),
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textMain),
      ),
    );
  }
}
