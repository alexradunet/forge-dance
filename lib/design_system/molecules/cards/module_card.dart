import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../atoms/badges/app_badge.dart';

/// Module card molecule - Type X (2:3 aspect), Type XX (2:1), Type Double (square)
class ModuleCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final DifficultyLevel? difficulty;
  final String? duration;
  final ModuleCardType type;
  final VoidCallback? onTap;

  const ModuleCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.difficulty,
    this.duration,
    this.type = ModuleCardType.x,
    this.onTap,
  });

  DifficultyLevel _getDifficultyLevel(DifficultyLevel? difficulty) {
    return difficulty ?? DifficultyLevel.beginner;
  }

  AppBadgeColor _getBadgeColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return AppBadgeColor.success;
      case DifficultyLevel.intermediate:
        return AppBadgeColor.warning;
      case DifficultyLevel.advanced:
        return AppBadgeColor.brand;
    }
  }

  String _getBadgeText(DifficultyLevel difficulty) {
    return difficulty.name.toUpperCase().substring(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ModuleCardType.x:
        return _buildTypeX();
      case ModuleCardType.xx:
        return _buildTypeXX();
      case ModuleCardType.double:
        return _buildTypeDouble();
    }
  }

  Widget _buildTypeX() {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.gray800,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: AppColors.gray800),
                  ),
                ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (difficulty != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppBadge(
                          text: _getBadgeText(difficulty!),
                          color: _getBadgeColor(difficulty!),
                          variant: AppBadgeVariant.solid,
                          shape: AppBadgeShape.pill,
                        ),
                      ),
                    Text(
                      title,
                      style: AppTheme.h5.copyWith(
                        color: AppColors.crystalWhite,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppColors.gray300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeXX() {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.gray800,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: AppColors.gray800),
                  ),
                ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (difficulty != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppBadge(
                          text: _getBadgeText(difficulty!),
                          color: _getBadgeColor(difficulty!),
                          variant: AppBadgeVariant.outline,
                          shape: AppBadgeShape.pill,
                        ),
                      ),
                    Text(
                      title,
                      style: AppTheme.h4.copyWith(
                        color: AppColors.crystalWhite,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppColors.gray300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeDouble() {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.gray800,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: AppColors.gray800),
                  ),
                ),
              // Heavy gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (difficulty != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppBadge(
                          text: _getBadgeText(difficulty!),
                          color: _getBadgeColor(difficulty!),
                          variant: AppBadgeVariant.solid,
                          shape: AppBadgeShape.pill,
                        ),
                      ),
                    Text(
                      title,
                      style: AppTheme.h2.copyWith(
                        color: AppColors.crystalWhite,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        subtitle!,
                        style: AppTheme.body.copyWith(
                          color: AppColors.gray300,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ModuleCardType {
  x, // 2:3 aspect
  xx, // 2:1 aspect
  double, // 1:1 aspect (square)
}

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
}
