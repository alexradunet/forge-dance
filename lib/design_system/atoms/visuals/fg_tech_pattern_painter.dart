import 'package:flutter/material.dart';

class FgTechPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final double spacing;
  final bool isGrid;

  const FgTechPatternPainter({
    required this.color,
    this.opacity = 0.2,
    this.spacing = 16.0,
    this.isGrid = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1.0;

    if (isGrid) {
      // Draw grid lines
      for (double i = 0; i <= size.width; i += spacing) {
        canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
      }
      for (double i = 0; i <= size.height; i += spacing) {
        canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
      }
    } else {
      // Draw dots
      for (double i = spacing / 2; i < size.width; i += spacing) {
        for (double j = spacing / 2; j < size.height; j += spacing) {
          canvas.drawCircle(Offset(i, j), 1.0, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant FgTechPatternPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.opacity != opacity ||
        oldDelegate.spacing != spacing ||
        oldDelegate.isGrid != isGrid;
  }
}
