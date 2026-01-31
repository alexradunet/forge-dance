import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppShadows,
  path: 'Design System/Tokens',
)
Widget buildShadowsPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: AppBorderRadius.medium,
          boxShadow: [
            BoxShadow(
              color: context.knobs.color(
                label: 'Color',
                initialValue: Colors.black.withOpacity(0.5),
              ),
              blurRadius: context.knobs.double
                  .slider(label: 'Blur', initialValue: 10, min: 0, max: 50),
              offset: Offset(
                0,
                context.knobs.double.slider(
                    label: 'Y Offset', initialValue: 4, min: 0, max: 20),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppShadows,
  path: 'Design System/Tokens',
)
Widget buildShadowsShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: ListView(
      padding: const EdgeInsets.all(32),
      children: [
        _ShadowRow(name: 'Small', shadow: [AppShadows.shadowSm]),
        _ShadowRow(name: 'Medium', shadow: [AppShadows.shadowMd]),
        _ShadowRow(name: 'Large', shadow: [AppShadows.shadowLg]),
        _ShadowRow(name: 'Extra Large', shadow: [AppShadows.shadowXl]),
        const Divider(height: 48, color: AppColors.gray800),
        _ShadowRow(name: 'Primary Glow', shadow: [AppShadows.glowPrimary]),
        _ShadowRow(name: 'Intense Glow', shadow: [AppShadows.glowIntense]),
        _ShadowRow(name: 'Blue Glow', shadow: [AppShadows.glowBlue]),
        _ShadowRow(name: 'Gold Glow', shadow: [AppShadows.glowGold]),
        _ShadowRow(name: 'Purple Glow', shadow: [AppShadows.glowPurple]),
      ],
    ),
  );
}

class _ShadowRow extends StatelessWidget {
  final String name;
  final List<BoxShadow> shadow;

  const _ShadowRow({required this.name, required this.shadow});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppBorderRadius.medium,
        boxShadow: shadow,
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textMain),
      ),
    );
  }
}
