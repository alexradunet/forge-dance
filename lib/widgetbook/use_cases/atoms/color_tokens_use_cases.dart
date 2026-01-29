import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

/// Color swatch widget for displaying a single color token
class ColorSwatch extends StatelessWidget {
  final String name;
  final String hexCode;
  final Color color;
  final String? description;

  const ColorSwatch({
    super.key,
    required this.name,
    required this.hexCode,
    required this.color,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.25),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (description != null)
            Text(
              description!,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              hexCode.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'JetBrains Mono',
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@widgetbook.UseCase(
  name: 'Primary Colors',
  type: ColorSwatch,
  path: '[Tokens]/Colors',
)
Widget buildPrimaryColors(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRIMARY COLORS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white54,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ColorSwatch(
                  name: 'Forge Fire',
                  hexCode: '#FF4500',
                  color: AppColors.forgeFire,
                  description: 'Primary CTA',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ColorSwatch(
                  name: 'Electric Blue',
                  hexCode: '#00BFFF',
                  color: AppColors.electricBlue,
                  description: 'Interactive / Focus',
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Accent Colors',
  type: ColorSwatch,
  path: '[Tokens]/Colors',
)
Widget buildAccentColors(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACCENT COLORS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white54,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ColorSwatch(
                  name: 'Legend Gold',
                  hexCode: '#FFD700',
                  color: AppColors.legendGold,
                  description: 'Warnings / Badges',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ColorSwatch(
                  name: 'Mystic Purple',
                  hexCode: '#8B00FF',
                  color: AppColors.mysticPurple,
                  description: 'Special States',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ColorSwatch(
                  name: 'Growth Green',
                  hexCode: '#10B981',
                  color: AppColors.growthGreen,
                  description: 'Success States',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ColorSwatch(
                  name: 'Passion Red',
                  hexCode: '#DC143C',
                  color: AppColors.passionRed,
                  description: 'High Intensity',
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Neutral Scale',
  type: ColorSwatch,
  path: '[Tokens]/Colors',
)
Widget buildNeutralColors(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NEUTRAL SCALE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white54,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          _buildNeutralRow('Neutral 50', '#F9FAFB', AppColors.neutral50, 'High Contrast Text'),
          _buildNeutralRow('Neutral 200', '#E5E5E5', AppColors.neutral200, 'Borders / Dividers'),
          _buildNeutralRow('Neutral 400', '#A3A3A3', AppColors.neutral400, 'Disabled Text'),
          _buildNeutralRow('Neutral 600', '#525252', AppColors.neutral600, 'Secondary Icons'),
          _buildNeutralRow('Neutral 800', '#262626', AppColors.neutral800, 'Card Surface'),
          _buildNeutralRow('Neutral 950', '#0A0A0A', AppColors.neutral950, 'App Background'),
        ],
      ),
    ),
  );
}

Widget _buildNeutralRow(String name, String hex, Color color, String desc) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.03),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        Text(
          hex,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'JetBrains Mono',
            color: Colors.white54,
          ),
        ),
      ],
    ),
  );
}
