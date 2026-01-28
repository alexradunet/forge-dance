import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';
import '../../molecules/cards/wod_card.dart';

/// Featured workout card organism - Hero card with gradient overlay, tags, CTA button
/// This is essentially a wrapper around WODCard with specific styling for featured content
class FeaturedWorkoutCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final int? level;
  final String? duration;
  final String? focus;
  final int? forgePoints;
  final VoidCallback? onStart;

  const FeaturedWorkoutCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.level,
    this.duration,
    this.focus,
    this.forgePoints,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return WODCard(
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      level: level,
      duration: duration,
      focus: focus,
      forgePoints: forgePoints,
      onStart: onStart,
    );
  }
}
