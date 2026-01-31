import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_shadows.dart';

class AppInteractiveCard extends StatefulWidget {
  final String title;
  final String? level;
  final String backgroundImage;
  final List<String> tags;
  final Widget? topLeftSlot;
  final Widget? topRightSlot;
  final Widget? child; // Bottom detail section
  final Widget? backContent;
  final VoidCallback? onTap;

  const AppInteractiveCard({
    super.key,
    required this.title,
    required this.backgroundImage,
    this.level,
    this.tags = const [],
    this.topLeftSlot,
    this.topRightSlot,
    this.child,
    this.backContent,
    this.onTap,
  });

  @override
  State<AppInteractiveCard> createState() => _AppInteractiveCardState();
}

class _AppInteractiveCardState extends State<AppInteractiveCard> {
  bool _isFlipped = false;

  void _toggleFlip() {
    if (widget.backContent != null) {
      setState(() {
        _isFlipped = !_isFlipped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _isFlipped ? 180 : 0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
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
        boxShadow: [AppShadows.glowPrimary],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              widget.backgroundImage,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.1),
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
          // Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black26,
                    Colors.transparent,
                    AppColors.bgDeep,
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          // Content
          Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      if (widget.topLeftSlot != null) widget.topLeftSlot!
                    ]),
                    Row(
                      children: [
                        if (widget.topRightSlot != null) widget.topRightSlot!,
                        if (widget.backContent != null) ...[
                          const SizedBox(width: 8),
                          _buildFlipButton(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Info
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags
                    Wrap(
                      spacing: 8,
                      children: [
                        ...widget.tags.asMap().entries.map((entry) {
                          final isFirst = entry.key == 0;
                          return _buildTag(entry.value, isFirst);
                        }),
                        if (widget.level != null)
                          _buildTag(widget.level!, false),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Bebas Neue',
                        fontSize: 60,
                        color: Colors.white,
                        height: 0.9,
                        shadows: [
                          Shadow(
                              color: Colors.black54,
                              blurRadius: 10,
                              offset: Offset(0, 4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Footer / Detail
              if (widget.child != null)
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: Colors.black.withOpacity(0.6),
                      child: widget.child!,
                    ),
                  ),
                ),
            ],
          ),
          // Tap overlay
          if (widget.onTap != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: widget.onTap),
              ),
            ),
        ],
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
        boxShadow: [AppShadows.glowPrimary],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topRight,
              child: _buildFlipButton(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: widget.backContent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlipButton() {
    return GestureDetector(
      onTap: _toggleFlip,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.4),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: const Icon(Icons.flip_camera_android,
            color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildTag(String text, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.forgeFire.withOpacity(0.9)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: !isPrimary
            ? Border.all(color: Colors.white.withOpacity(0.1))
            : null,
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
