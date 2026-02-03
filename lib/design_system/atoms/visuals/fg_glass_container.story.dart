import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgGlassContainer,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgGlassContainerPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent, // Transparent to see background
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.forgeFire, AppColors.electricBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: FgGlassContainer(
          borderRadius: context.knobs.double.slider(
              label: 'Border Radius', initialValue: 16, min: 0, max: 50),
          blurSigma: context.knobs.double
              .slider(label: 'Blur Sigma', initialValue: 10, min: 0, max: 30),
          opacity: context.knobs.double
              .slider(label: 'Opacity', initialValue: 0.1, min: 0, max: 1),
          borderWidth: context.knobs.double
              .slider(label: 'Border Width', initialValue: 1, min: 0, max: 5),
          padding: const EdgeInsets.all(24),
          child: const Text(
            'Frosted Glass',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgGlassContainer,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgGlassContainerShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Stack(
      children: [
        // Background for contrast
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.forgeFire, AppColors.electricBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
                child: Icon(Icons.grid_4x4, size: 300, color: Colors.white10)),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Standard Glass',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              const FgGlassContainer(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text('Premium Feature',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text('High Blur & Darker',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              FgGlassContainer(
                blurSigma: 20,
                opacity: 0.3,
                color: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Text('More Info', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text('With Shadow', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              FgGlassContainer(
                padding: const EdgeInsets.all(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: const Text('Glowing Glass',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
