import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';

/// User avatar atom - With level badges, online status, notification counts
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final int? level;
  final bool isOnline;
  final int? notificationCount;
  final double size;
  final Color? borderColor;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.level,
    this.isOnline = false,
    this.notificationCount,
    this.size = 56,
    this.borderColor,
  });

  const UserAvatar.large({
    super.key,
    this.imageUrl,
    this.initials,
    this.level,
    this.isOnline = false,
    this.notificationCount,
    this.size = 80,
    this.borderColor,
  });

  const UserAvatar.medium({
    super.key,
    this.imageUrl,
    this.initials,
    this.level,
    this.isOnline = false,
    this.notificationCount,
    this.size = 56,
    this.borderColor,
  });

  const UserAvatar.small({
    super.key,
    this.imageUrl,
    this.initials,
    this.level,
    this.isOnline = false,
    this.notificationCount,
    this.size = 40,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.forgeFire;
    final borderWidth = size > 60 ? 3.0 : 2.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: border,
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: border.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipOval(
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
        ),
        // Level badge
        if (level != null)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: AppColors.forgeFire,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gray950,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '$level',
                  style: AppTheme.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.crystalWhite,
                    fontSize: size * 0.15,
                  ),
                ),
              ),
            ),
          ),
        // Online status
        if (isOnline)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: AppColors.growthGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gray950,
                  width: 2,
                ),
              ),
            ),
          ),
        // Notification count
        if (notificationCount != null && notificationCount! > 0)
          Positioned(
            top: -6,
            left: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.forgeFire,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gray950,
                  width: 2,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Center(
                child: Text(
                  notificationCount! > 9 ? '9+' : '${notificationCount!}',
                  style: AppTheme.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.crystalWhite,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.gray800,
      child: initials != null
          ? Center(
              child: Text(
                initials!.toUpperCase(),
                style: AppTheme.h6.copyWith(
                  color: AppColors.crystalWhite,
                  fontSize: size * 0.4,
                ),
              ),
            )
          : Icon(
              Icons.person,
              size: size * 0.6,
              color: AppColors.gray400,
            ),
    );
  }
}
