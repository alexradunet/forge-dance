import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

/// Portrait Card - Workshop module container with content stack
/// Based on HTML mockup: forge.dance_home_dashboard_3 (02. Standard Portrait Card)
class PortraitCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? badgeText;
  final String? participantCount;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? actionIcon;

  const PortraitCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.badgeText,
    this.participantCount,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: AppBorderRadius.extraLarge,
        border: Border.all(
          color: AppColors.crystalWhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section (square)
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (imageUrl != null)
                  CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.bgDeep,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.bgDeep,
                      child:
                          const Icon(Icons.image, color: AppColors.textMuted),
                    ),
                  )
                else
                  Container(color: AppColors.bgDeep),

                // Overlay
                Container(
                  color: Colors.black.withOpacity(0.2),
                ),

                // Badge
                if (badgeText != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.forgeFire,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badgeText!.toUpperCase(),
                        style: AppTypography.overline.copyWith(
                          color: AppColors.crystalWhite,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0x33FFFFFF),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h3.copyWith(
                    color: AppColors.crystalWhite,
                    fontSize: 24,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),

                // Participants row
                if (participantCount != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        // Avatar stack placeholder
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.bgDeep,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.bgDeep,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$participantCount joined',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Action button
                if (actionLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: GestureDetector(
                      onTap: onAction,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.crystalWhite.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.crystalWhite.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (actionIcon != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  actionIcon,
                                  color: AppColors.crystalWhite,
                                  size: 14,
                                ),
                              ),
                            Text(
                              actionLabel!.toUpperCase(),
                              style: AppTypography.overline.copyWith(
                                color: AppColors.crystalWhite,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
