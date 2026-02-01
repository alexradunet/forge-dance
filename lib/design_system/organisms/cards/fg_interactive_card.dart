import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_tech_pattern_painter.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_typography.dart';

class FgInteractiveCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String backgroundImage;
  final List<String> tags;
  final String? level;
  final String? style;
  final String? difficulty;
  final double progress;
  final bool isPlaying;
  final Widget? backContent;
  final String? backTitle;
  final String? backSubtitle;
  final Widget? backFooter;
  final VoidCallback? onTap;
  final VoidCallback? onPlayTap;
  final bool isFavorited;
  final VoidCallback? onToggleFavorite;
  final Widget? footer;
  final bool initialFlipped;

  const FgInteractiveCard({
    super.key,
    required this.title,
    required this.backgroundImage,
    this.subtitle,
    this.tags = const [],
    this.level,
    this.style,
    this.difficulty,
    this.progress = 0.3,
    this.isPlaying = false,
    this.backContent,
    this.backTitle,
    this.backSubtitle,
    this.backFooter,
    this.onTap,
    this.onPlayTap,
    this.isFavorited = false,
    this.onToggleFavorite,
    this.footer,
    this.initialFlipped = false,
  });

  @override
  State<FgInteractiveCard> createState() => _FgInteractiveCardState();
}

class _FgInteractiveCardState extends State<FgInteractiveCard>
    with SingleTickerProviderStateMixin {
  late bool _isFlipped;

  @override
  void initState() {
    super.initState();
    _isFlipped = widget.initialFlipped;
  }

  void _toggleFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _isFlipped ? 180 : 0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutBack,
      builder: (context, angle, child) {
        final isBackVisible = angle >= 90;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
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
    );
  }

  Widget _buildFront() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppBorderRadius.xxLarge,
        border:
            Border.all(color: AppColors.forgeFire.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.forgeFire.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            // Main Content Area (Flex Grow)
            Expanded(
              child: Stack(
                children: [
                  // Media Layer
                  Positioned.fill(
                    child: Image.network(
                      widget.backgroundImage,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.6),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),

                  // Tech Pattern Overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: FgTechPatternPainter(
                        color: Colors.white,
                        opacity: 0.1,
                        spacing: 16.0,
                      ),
                    ),
                  ),

                  // Overlay Gradient
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

                  // Centered Title & Subtitle
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.subtitle != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color:
                                        AppColors.forgeFire.withOpacity(0.3)),
                              ),
                              child: Text(
                                widget.subtitle!.toUpperCase(),
                                style: AppTypography.label.copyWith(
                                  color: AppColors.forgeFire,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Text(
                            widget.title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: AppTypography.h1.copyWith(
                              color: Colors.white,
                              fontSize: 56,
                              height: 0.9,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                    color: Colors.black.withOpacity(0.8),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Play Button Overlay
                  Center(
                    child: GestureDetector(
                      onTap: widget.onPlayTap,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Center(
                          child: Icon(Icons.play_arrow,
                              color: Colors.white, size: 32),
                        ),
                      ),
                    ),
                  ),

                  // Top Right: Favorite
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: widget.onToggleFavorite,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Icon(
                          widget.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.isFavorited
                              ? AppColors.forgeFire
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Bottom Right: Flip
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: _toggleFlip,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Icon(Icons.replay,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),

                  // Progress Bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      color: Colors.white.withOpacity(0.1),
                      child: Row(
                        children: [
                          Expanded(
                            flex: (widget.progress * 100).toInt(),
                            child: Container(color: AppColors.forgeFire),
                          ),
                          Expanded(
                            flex: ((1 - widget.progress) * 100).toInt(),
                            child: const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Progress Handle
                  Positioned(
                    bottom: 0,
                    left: (widget.progress * -10)
                        .toDouble(), // Pseudo-offset alignment
                    child: Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.4 *
                              widget.progress),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.black.withOpacity(0.6),
              child: widget.footer ??
                  Row(
                    children: [
                      _buildFooterStat('STYLE', widget.style ?? 'Hip Hop',
                          Icons.style, Colors.blueAccent),
                      Container(
                          width: 1,
                          height: 24,
                          color: Colors.white.withOpacity(0.1),
                          margin: const EdgeInsets.symmetric(horizontal: 16)),
                      _buildFooterStat(
                          'DIFFICULTY',
                          widget.difficulty ?? 'Easy',
                          Icons.signal_cellular_alt,
                          Colors.greenAccent),
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
        border:
            Border.all(color: AppColors.forgeFire.withOpacity(0.5), width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Tech Grid Pattern
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

          Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40), // Spacer for center alignment
                    if (widget.backSubtitle != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: AppColors.forgeFire.withOpacity(0.3)),
                        ),
                        child: Text(
                          widget.backSubtitle!.toUpperCase(),
                          style: AppTypography.label.copyWith(
                              color: AppColors.forgeFire, fontSize: 8),
                        ),
                      ),
                    GestureDetector(
                      onTap: widget.onToggleFavorite,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Icon(
                          widget.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.isFavorited
                              ? AppColors.forgeFire
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.backTitle != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    widget.backTitle!.toUpperCase(),
                    style: AppTypography.h2.copyWith(
                        color: Colors.white, fontSize: 32, letterSpacing: 2),
                  ),
                ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: widget.backContent ??
                      const Center(
                          child: Text('No details available',
                              style: TextStyle(color: Colors.white54))),
                ),
              ),

              // Bottom Right: Flip (Back side)
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _toggleFlip,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.replay,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),

              // Back Footer
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                color: Colors.black.withOpacity(0.6),
                child: widget.backFooter ??
                    Row(
                      children: [
                        _buildFooterStat(
                            'TIME SIG', '4/4', Icons.timer, Colors.white54),
                        Container(
                            width: 1,
                            height: 24,
                            color: Colors.white.withOpacity(0.1),
                            margin: const EdgeInsets.symmetric(horizontal: 16)),
                        _buildFooterStat(
                            'TEMPO', '120 BPM', Icons.flash_on, Colors.white54),
                      ],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterStat(
      String label, String value, IconData icon, Color accentColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 10, color: accentColor.withOpacity(0.6)),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.label.copyWith(
                    color: AppColors.textDark,
                    fontSize: 8,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.bodySmall
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
