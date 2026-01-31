import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_border_radius.dart';
import '../../design_system/tokens/app_animation.dart';

/// Interactive Card Template - Stacked card with Flip functionality
/// Supports Front and Back content
class InteractiveCardTemplate extends StatefulWidget {
  final Widget frontContent;
  final Widget backContent;
  final Color accentColor;

  const InteractiveCardTemplate({
    super.key,
    required this.frontContent,
    required this.backContent,
    this.accentColor = AppColors.forgeFire,
  });

  @override
  State<InteractiveCardTemplate> createState() =>
      _InteractiveCardTemplateState();
}

class _InteractiveCardTemplateState extends State<InteractiveCardTemplate>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _frontAnimation;
  late Animation<double> _backAnimation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: AppAnimation.fadeIn,
    );

    _frontAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -math.pi / 2)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: ConstantTween(-math.pi / 2),
        weight: 50,
      ),
    ]).animate(_flipController);

    _backAnimation = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween(math.pi / 2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: math.pi / 2, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(_flipController);
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Deck Effect
              _buildBackgroundCard(top: 16, widthOffset: 64, opacity: 0.1),
              _buildBackgroundCard(top: 8, widthOffset: 40, opacity: 0.1),

              // Main Flippable Card
              Stack(
                children: [
                  // Back Side
                  AnimatedBuilder(
                    animation: _backAnimation,
                    builder: (context, child) {
                      final transform = Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_backAnimation.value);
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: _backAnimation.value < math.pi / 2
                            ? _buildCardFace(
                                content: widget.backContent,
                                isFront: false,
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                  // Front Side
                  AnimatedBuilder(
                    animation: _frontAnimation,
                    builder: (context, child) {
                      final transform = Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_frontAnimation.value);
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: _frontAnimation.value > -math.pi / 2
                            ? _buildCardFace(
                                content: widget.frontContent,
                                isFront: true,
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundCard({
    required double top,
    required double widthOffset,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: -20, // Extends below to simulate stack
      left: widthOffset / 2,
      right: widthOffset / 2,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: AppBorderRadius.xxLarge,
          border: Border.all(
            color: AppColors.crystalWhite.withAlpha((opacity * 255).round()),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildCardFace({required Widget content, required bool isFront}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: AppBorderRadius.xxLarge,
        border: Border.all(
          color: isFront
              ? widget.accentColor.withAlpha((0.5 * 255).round())
              : AppColors.textMuted.withAlpha((0.3 * 255).round()),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isFront
                ? widget.accentColor.withAlpha((0.3 * 255).round())
                : Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Content
          Positioned.fill(child: content),

          // Flip Button (Always visible on top right)
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: _toggleCard,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.crystalWhite.withAlpha((0.05 * 255).round()),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        AppColors.crystalWhite.withAlpha((0.1 * 255).round()),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.flip_camera_android,
                  color: isFront ? AppColors.textMuted : AppColors.forgeFire,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
