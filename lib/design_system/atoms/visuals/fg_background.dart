import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

class FgBackground extends StatelessWidget {
  final Widget? child;
  final bool showGrid;
  final bool showGradients;

  const FgBackground({
    super.key,
    this.child,
    this.showGrid = true,
    this.showGradients = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgDeep,
      child: Stack(
        children: [
          if (showGradients) _buildBackgroundGradients(),
          if (showGrid) _buildGridBackground(),
          if (child != null) child!,
        ],
      ),
    );
  }

  Widget _buildGridBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GridPainter(color: Colors.white.withOpacity(0.05)),
      ),
    );
  }

  Widget _buildBackgroundGradients() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.forgeFire.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.electricBlue.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const step = 32.0;

    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
