import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgGradientOverlay,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgGradientOverlayPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey, // Grey to see overlay clearly
    body: Stack(
      children: [
        // Placeholder background content
        Positioned.fill(
          child: Image.network(
            'https://picsum.photos/seed/dance/800/1200',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: FgGradientOverlay(
            height: context.knobs.double
                .slider(label: 'Height', initialValue: 300, min: 50, max: 600),
            colors: [
              Colors.transparent,
              context.knobs
                  .color(label: 'End Color', initialValue: AppColors.bgDeep),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgGradientOverlay,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgGradientOverlayShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray900,
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Fade to Bottom (Standard)',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.blueGrey,
            child: Stack(
              children: [
                const Center(
                    child: Text('Background Image Placeholder',
                        style: TextStyle(color: Colors.white54))),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: FgGradientOverlay.fadeToBottom(),
                ),
                const Positioned(
                  bottom: 24,
                  left: 24,
                  child: Text('Title on Gradient',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Fade to Top (Header Scrim)',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 300,
            width: double.infinity,
            color: AppColors.passionRed,
            child: Stack(
              children: [
                const Center(
                    child: Text('Background Image Placeholder',
                        style: TextStyle(color: Colors.white54))),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: FgGradientOverlay.fadeToTop(),
                ),
                const Positioned(
                  top: 16,
                  left: 16,
                  child: SafeArea(
                      child: Icon(Icons.arrow_back, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
