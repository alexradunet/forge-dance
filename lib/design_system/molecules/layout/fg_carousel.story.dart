import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';
import 'package:flutter_mvvm_riverpod/design_system/molecules/layout/fg_carousel.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgCarousel,
  path: 'Design System/Molecules/Layout',
)
Widget buildFgCarouselPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: SizedBox(
        height: 200,
        child: FgCarousel(
          viewportFraction: context.knobs.double.slider(
              label: 'Viewport Fraction',
              initialValue: 0.8,
              min: 0.5,
              max: 1.0),
          enableScaleEffect: context.knobs
              .boolean(label: 'Enable Scale Effect', initialValue: true),
          isEnabled:
              context.knobs.boolean(label: 'Enabled', initialValue: true),
          items: List.generate(
            5,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? AppColors.forgeFire
                    : AppColors.electricBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                'Item ${index + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgCarousel,
  path: 'Design System/Molecules/Layout',
)
Widget buildFgCarouselShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Full Width (Standard)',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: FgCarousel(
            viewportFraction: 1.0,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            items: List.generate(
                3,
                (index) => FgCard(
                      variant: FgCardVariant.opaque,
                      color: AppColors.gray800,
                      child: Center(
                          child: Text('Card ${index + 1}',
                              style: const TextStyle(color: Colors.white))),
                    )),
          ),
        ),
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Scaled Peek (0.8)',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: FgCarousel(
            viewportFraction: 0.8,
            enableScaleEffect: true,
            items: List.generate(
                3,
                (index) => FgCard(
                      variant: FgCardVariant.elevated,
                      color: AppColors.surfaceCard,
                      child: Center(
                          child: Text('Peek ${index + 1}',
                              style: const TextStyle(color: Colors.white))),
                    )),
          ),
        ),
      ],
    ),
  );
}
