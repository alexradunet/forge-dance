import 'package:flutter/material.dart';

class FgIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool filled;

  const FgIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    // In Flutter, many icons have 'outlined' and 'rounded' versions in the material icons set.
    // If the user wants a 'filled' effect consistently, we'd use the standard Icon.
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}
