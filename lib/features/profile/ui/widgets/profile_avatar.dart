import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../constants/assets.dart';
import '../../../../extensions/string_extension.dart';
import '../../../../design_system/tokens/app_colors.dart';

/// Enhanced profile avatar with animated gradient border and level badge
class ProfileAvatar extends StatelessWidget {
  final String? url;
  final String? levelBadge;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.url,
    this.levelBadge,
    this.radius = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Animated gradient border
            Container(
              width: radius * 2 + 12,
              height: radius * 2 + 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.forgeFire,
                    AppColors.legendGold.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            // Inner dark border
            Positioned.fill(
              child: Center(
                child: Container(
                  width: radius * 2 + 6,
                  height: radius * 2 + 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgDeep,
                  ),
                ),
              ),
            ),
            // Avatar image
            Positioned.fill(
              child: Center(
                child: Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceDark,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _buildImage(),
                  ),
                ),
              ),
            ),
            // Level badge at bottom
            if (levelBadge != null)
              Positioned(
                bottom: -8,
                left: 0,
                right: 0,
                child: Center(
                  child: _buildLevelBadge(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (url == null) {
      return Image.asset(
        Assets.avatar,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );
    }

    if (url!.isUrl) {
      return CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        placeholder: (context, url) => Container(
          color: AppColors.surfaceDark,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.forgeFire,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          Assets.avatar,
          fit: BoxFit.cover,
        ),
      );
    }

    if (File(url!).existsSync()) {
      return Image.file(
        File(url!),
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );
    }

    return Image.asset(
      Assets.avatar,
      fit: BoxFit.cover,
      width: radius * 2,
      height: radius * 2,
    );
  }

  Widget _buildLevelBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD700), // Legend Gold
            Color(0xFFFFA500), // Orange
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.bgDeep,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.legendGold.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.bgDeep.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            levelBadge!.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
