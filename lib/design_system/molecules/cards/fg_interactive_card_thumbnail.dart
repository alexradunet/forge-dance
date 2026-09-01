import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/atoms/visuals/fg_tech_pattern_painter.dart';

import '../../atoms/buttons/fg_icon_button.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_typography.dart';

class FgInteractiveCardThumbnail extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String backgroundImage;
  final String? level;
  final Function(bool)? onTap;
  final String flipSemanticLabel;

  // Back content specific to thumbnails (simplified)
  final String? backTitle;
  final String? backSubtitle;

  const FgInteractiveCardThumbnail({
    super.key,
    required this.title,
    required this.backgroundImage,
    required this.flipSemanticLabel,
    this.subtitle,
    this.level,
    this.onTap,
    this.backTitle,
    this.backSubtitle,
  });

  @override
  State<FgInteractiveCardThumbnail> createState() =>
      _FgInteractiveCardThumbnailState();
}

class _FgInteractiveCardThumbnailState extends State<FgInteractiveCardThumbnail>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;

  void _toggleFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final motion = context.forgeMotion;

    return Stack(
      children: [
        Positioned.fill(
          child: Semantics(
            label: widget.title,
            button: widget.onTap != null,
            enabled: widget.onTap != null,
            onTap: widget.onTap == null
                ? null
                : () => widget.onTap!.call(_isFlipped),
            child: ExcludeSemantics(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: _isFlipped ? 180 : 0),
                duration: motion.slow,
                curve: motion.enterCurve,
                builder: (context, angle, child) {
                  final isBackVisible = angle >= 90;

                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle * pi / 180),
                    alignment: Alignment.center,
                    child: isBackVisible
                        ? Transform(
                            transform: Matrix4.identity()..rotateY(pi),
                            alignment: Alignment.center,
                            child: _buildBack(),
                          )
                        : _buildFront(),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: FgIconButton(
            icon: Icons.replay_rounded,
            semanticLabel: widget.flipSemanticLabel,
            size: FgIconButtonSize.sm,
            variant: FgIconButtonVariant.ghost,
            onPressed: _toggleFlip,
          ),
        ),
      ],
    );
  }

  Widget _buildFront() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppBorderRadius.xxLarge,
        border: Border.all(
          color: AppColors.forgeFire.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.forgeFire.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.onTap?.call(_isFlipped),
        excludeFromSemantics: true,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Media
                  Positioned.fill(
                    child: Image.network(
                      widget.backgroundImage,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.6),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),

                  // Pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: FgTechPatternPainter(
                        color: Colors.white,
                        opacity: 0.1,
                        spacing: 16.0,
                      ),
                    ),
                  ),

                  // Gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.subtitle != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.forgeFire.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                widget.subtitle!.toUpperCase(),
                                style: AppTypography.label.copyWith(
                                  color: AppColors.forgeFire,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Text(
                            widget.title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: AppTypography.h1.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                              height: 0.9,
                              letterSpacing: 1.0,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.8),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppBorderRadius.xxLarge,
        border: Border.all(
          color: AppColors.forgeFire.withOpacity(0.5),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.onTap?.call(_isFlipped),
        excludeFromSemantics: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: FgTechPatternPainter(
                  color: Colors.white,
                  opacity: 0.1,
                  spacing: 20.0,
                  isGrid: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.backSubtitle != null)
                    Text(
                      widget.backSubtitle!.toUpperCase(),
                      style: AppTypography.label.copyWith(
                        color: AppColors.forgeFire,
                        fontSize: 8,
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (widget.backTitle != null)
                    Text(
                      widget.backTitle!.toUpperCase(),
                      style: AppTypography.h3.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 12),
                  // Hardcoded rhythm visual for now as per original mini card design
                  // Since this is a thumbnail, it serves as a preview.
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRhythmBar('Kick', 0.8, Colors.orange),
                        const SizedBox(height: 8),
                        _buildRhythmBar('Snare', 0.6, Colors.blue),
                        const SizedBox(height: 8),
                        _buildRhythmBar('Hi-Hat', 0.9, Colors.purple),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRhythmBar(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 8)),
        const SizedBox(height: 2),
        Stack(
          children: [
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.8), color],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.4), blurRadius: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
