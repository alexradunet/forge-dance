import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_typography.dart';

/// Typography sample widget for displaying text styles
class TypographySample extends StatelessWidget {
  final String label;
  final String sizeInfo;
  final TextStyle style;
  final String sampleText;

  const TypographySample({
    super.key,
    required this.label,
    required this.sizeInfo,
    required this.style,
    required this.sampleText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrains Mono',
                  color: Colors.white54,
                ),
              ),
              Text(
                sizeInfo,
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrains Mono',
                  color: Colors.white38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(sampleText, style: style),
        ],
      ),
    );
  }
}

@widgetbook.UseCase(
  name: 'Display Headers',
  type: TypographySample,
  path: 'Design System/Tokens',
)
Widget buildDisplayHeaders(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DISPLAY HEADERS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                    letterSpacing: 2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Text(
                    'Bebas Neue Bold',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'JetBrains Mono',
                      color: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TypographySample(
            label: 'H1 / Header',
            sizeInfo: '48px / 1.0 LH',
            style: AppTheme.h1.copyWith(color: Colors.white),
            sampleText: 'FORGE HEADLINE',
          ),
          TypographySample(
            label: 'H2 / Section Title',
            sizeInfo: '36px / 1.0 LH',
            style: AppTheme.h2.copyWith(color: Colors.white),
            sampleText: 'SECTION TITLE',
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'UI Labels',
  type: TypographySample,
  path: '[Tokens]/Typography',
)
Widget buildUILabels(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'UI LABELS & HEADERS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                    letterSpacing: 2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Text(
                    'Inter Semibold',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'JetBrains Mono',
                      color: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TypographySample(
            label: 'H3 / Card Header',
            sizeInfo: '30px / 1.2 LH',
            style: AppTheme.h3.copyWith(color: Colors.white),
            sampleText: 'Card Header Title',
          ),
          TypographySample(
            label: 'H4 / Component Label',
            sizeInfo: '24px / 1.4 LH',
            style: AppTheme.h4.copyWith(color: Colors.white),
            sampleText: 'Component Label',
          ),
          TypographySample(
            label: 'H5 / Modal Title',
            sizeInfo: '20px / 1.4 LH',
            style: AppTheme.h5.copyWith(color: Colors.white),
            sampleText: 'Modal Window Title',
          ),
          TypographySample(
            label: 'H6 / Small Label',
            sizeInfo: '18px / 1.5 LH',
            style: AppTheme.h6.copyWith(color: Colors.white),
            sampleText: 'Small UI Label',
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Body & Technical',
  type: TypographySample,
  path: '[Tokens]/Typography',
)
Widget buildBodyTypography(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'BODY & TECHNICAL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                    letterSpacing: 2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Text(
                    'Inter & JetBrains',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'JetBrains Mono',
                      color: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildBodyCard(
            'Body Regular',
            '16px / 1.6 LH',
            AppTheme.bodyLarge,
            'Forge creates digital experiences that matter. Primary body text is optimized for readability at small sizes.',
          ),
          const SizedBox(height: 16),
          _buildBodyCard(
            'Body Small',
            '14px / 1.5 LH',
            AppTheme.body,
            'Secondary descriptions, captions, and helper text often use this smaller variant. It maintains legibility while taking up less visual weight.',
          ),
          const SizedBox(height: 16),
          _buildMonoCard(),
        ],
      ),
    ),
  );
}

Widget _buildBodyCard(String label, String sizeInfo, TextStyle style, String text) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surfaceDark.withOpacity(0.4),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontFamily: 'JetBrains Mono',
                color: Colors.white,
              ),
            ),
            Text(
              sizeInfo,
              style: const TextStyle(
                fontSize: 10,
                fontFamily: 'JetBrains Mono',
                color: Colors.white54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(text, style: style.copyWith(color: Colors.grey[300])),
      ],
    ),
  );
}

Widget _buildMonoCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0F0F0F),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mono / Technical',
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'JetBrains Mono',
                color: AppColors.electricBlue,
              ),
            ),
            const Text(
              '13px / 1.5 LH',
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'JetBrains Mono',
                color: Colors.white54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'JetBrains Mono',
              height: 1.5,
              color: Colors.grey,
            ),
            children: [
              TextSpan(text: 'const ', style: TextStyle(color: AppColors.forgeFire)),
              const TextSpan(text: 'config = {\n'),
              const TextSpan(text: '  theme: '),
              TextSpan(text: '"dark"', style: TextStyle(color: AppColors.electricBlue)),
              const TextSpan(text: ',\n'),
              const TextSpan(text: '  version: '),
              TextSpan(text: '1.0', style: TextStyle(color: AppColors.electricBlue)),
              const TextSpan(text: ',\n'),
              const TextSpan(text: '  status: '),
              TextSpan(text: 'true', style: TextStyle(color: AppColors.forgeFire)),
              const TextSpan(text: '\n};'),
            ],
          ),
        ),
      ],
    ),
  );
}
