import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

/// Skeleton loader atom - For cards, lists, avatars
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  const SkeletonLoader.avatar({
    super.key,
    double? size,
  })  : width = size ?? 56,
        height = size ?? 56,
        borderRadius = BorderRadius.circular(size ?? 56);

  const SkeletonLoader.card({
    super.key,
    double? width,
    double? height,
  })  : width = width ?? double.infinity,
        height = height ?? 200,
        borderRadius = BorderRadius.circular(16);

  const SkeletonLoader.text({
    super.key,
    double? width,
    double height = 16,
  })  : width = width ?? double.infinity,
        height = height,
        borderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray800,
      highlightColor: AppColors.gray700,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.gray800,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Skeleton list item - For list loading states
class SkeletonListItem extends StatelessWidget {
  final bool hasAvatar;
  final int lines;

  const SkeletonListItem({
    super.key,
    this.hasAvatar = true,
    this.lines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasAvatar) ...[
            const SkeletonLoader.avatar(),
            const SizedBox(width: AppSpacing.lg),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                lines,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index < lines - 1 ? AppSpacing.sm : 0,
                  ),
                  child: SkeletonLoader.text(
                    width: index == 0 ? double.infinity : double.infinity * 0.7,
                    height: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
