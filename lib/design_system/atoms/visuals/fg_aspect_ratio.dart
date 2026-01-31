import 'package:flutter/material.dart';

/// A convenience atom to enforce aspect ratios on content.
class FgAspectRatio extends StatelessWidget {
  final double ratio;
  final Widget child;

  const FgAspectRatio({
    super.key,
    required this.ratio,
    required this.child,
  });

  /// Standard 16:9 for video
  factory FgAspectRatio.video({required Widget child}) {
    return FgAspectRatio(ratio: 16 / 9, child: child);
  }

  /// Standard 4:3 for photos
  factory FgAspectRatio.photo({required Widget child}) {
    return FgAspectRatio(ratio: 4 / 3, child: child);
  }

  /// Standard 1:1 for square avatars/tiles
  factory FgAspectRatio.square({required Widget child}) {
    return FgAspectRatio(ratio: 1, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio,
      child: child,
    );
  }
}
