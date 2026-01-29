import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_shadows.dart';

/// Navigation Tab Bar with elevated FAB action
/// Based on HTML mockup: forge.dance_home_dashboard_1
class ForgeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final VoidCallback? onFabPressed;
  final List<ForgeNavItem> items;
  final String? fabLabel;
  final IconData? fabIcon;

  const ForgeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    this.onTap,
    this.onFabPressed,
    this.fabLabel = 'IGNITE',
    this.fabIcon = Icons.local_fire_department,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate center index for FAB
    final fabIndex = items.length ~/ 2;
    
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: AppColors.neutral900.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.crystalWhite.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: const [AppShadows.shadowXl],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Tab items
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                for (int i = 0; i < items.length; i++)
                  if (i == fabIndex)
                    // Spacer for FAB
                    const SizedBox(width: 80)
                  else
                    Expanded(
                      child: _NavTab(
                        item: items[i],
                        isActive: currentIndex == i,
                        onTap: () => onTap?.call(i),
                      ),
                    ),
              ],
            ),
          ),
          
          // FAB (centered)
          Positioned(
            left: 0,
            right: 0,
            top: -32,
            child: Center(
              child: _FabButton(
                icon: fabIcon!,
                label: fabLabel,
                onPressed: onFabPressed,
              ),
            ),
          ),
          
          // Home indicator
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 128,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.crystalWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final ForgeNavItem item;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavTab({
    required this.item,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 76,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              color: isActive ? AppColors.forgeFire : AppColors.textMuted,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTypography.overline.copyWith(
                color: isActive ? AppColors.forgeFire : AppColors.textMuted,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            // Active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.forgeFire : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.forgeFire.withOpacity(0.4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;

  const _FabButton({
    required this.icon,
    this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Glow effect
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.forgeFire.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.forgeFire,
                    AppColors.forgeFireDark,
                  ],
                ),
                border: Border.all(
                  color: AppColors.bgDeep,
                  width: 6,
                ),
              ),
              child: Stack(
                children: [
                  // Highlight
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.crystalWhite.withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  // Icon
                  Center(
                    child: Icon(
                      icon,
                      color: AppColors.crystalWhite,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Label
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label!,
              style: AppTypography.overline.copyWith(
                color: AppColors.forgeFire,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

/// Navigation item model
class ForgeNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const ForgeNavItem({
    required this.label,
    required this.icon,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}
