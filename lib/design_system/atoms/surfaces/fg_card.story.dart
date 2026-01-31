import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/surfaces/fg_card.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgCard,
  path: 'Design System/Atoms/Surfaces',
)
Widget buildFgCardPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FgCard(
          variant: context.knobs.list(
            label: 'Variant',
            options: FgCardVariant.values,
            initialOption: FgCardVariant.opaque,
          ),
          onTap: context.knobs.boolean(label: 'Tappable', initialValue: false)
              ? () {}
              : null,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Card Title',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('This is the content inside the card.',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgCard,
  path: 'Design System/Atoms/Surfaces',
)
Widget buildFgCardShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        Text('Opaque (Default)', style: TextStyle(color: Colors.white)),
        SizedBox(height: 8),
        FgCard(
          variant: FgCardVariant.opaque,
          child: Text('Surface Card', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 24),
        Text('Outlined', style: TextStyle(color: Colors.white)),
        SizedBox(height: 8),
        FgCard(
          variant: FgCardVariant.outlined,
          child: Text('Outlined Card', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 24),
        Text('Elevated', style: TextStyle(color: Colors.white)),
        SizedBox(height: 8),
        FgCard(
          variant: FgCardVariant.elevated,
          child: Text('Elevated Card', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
