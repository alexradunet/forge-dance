import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';

/// Status dot atom - Animated ping effect for live status
class FgStatusDot extends StatefulWidget {
  final bool isLive;
  final Color? color;
  final double size;

  const FgStatusDot({
    super.key,
    this.isLive = true,
    this.color,
    this.size = 12,
  });

  @override
  State<FgStatusDot> createState() => _FgStatusDotState();
}

class _FgStatusDotState extends State<FgStatusDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.color ?? AppColors.forgeFire;

    if (!widget.isLive) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: AppColors.gray600,
          shape: BoxShape.circle,
        ),
      );
    }

    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Ping animation
              Container(
                width: widget.size * 2 * _animation.value,
                height: widget.size * 2 * _animation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: dotColor.withOpacity(1 - _animation.value),
                    width: 2,
                  ),
                ),
              ),
              // Main dot
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gray950,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: dotColor.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
