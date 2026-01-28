import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';
import '../../../features/common/ui/widgets/material_ink_well.dart';

/// Bottom navigation bar organism - With elevated "Ignite" FAB button, 5 tabs
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;
  final VoidCallback? onIgnitePressed;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onTabSelected,
    this.onIgnitePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withOpacity(0.95),
        border: Border(
          top: BorderSide(color: AppColors.gray700.withOpacity(0.1), width: 1),
        ),
      ),
      child: Stack(
        children: [
          // Tab buttons
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl + 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton(
                  icon: Icons.home,
                  label: 'Home',
                  index: 0,
                  isFilled: selectedIndex == 0,
                ),
                _buildTabButton(
                  icon: Icons.grid_view,
                  label: 'Explore',
                  index: 1,
                  isFilled: selectedIndex == 1,
                ),
                // Spacer for FAB
                const SizedBox(width: 80),
                _buildTabButton(
                  icon: Icons.bar_chart,
                  label: 'Stats',
                  index: 3,
                  isFilled: selectedIndex == 3,
                ),
                _buildTabButton(
                  icon: Icons.person,
                  label: 'Profile',
                  index: 4,
                  isFilled: selectedIndex == 4,
                ),
              ],
            ),
          ),
          // Elevated FAB
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.forgeFire,
                        const Color(0xFFE03E00),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.forgeFire.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.gray950,
                      width: 6,
                    ),
                  ),
                  child: MaterialInkWell(
                    onTap: onIgnitePressed,
                    radius: 36,
                    child: const Icon(
                      Icons.local_fire_department,
                      color: AppColors.crystalWhite,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'IGNITE',
                  style: AppTheme.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.forgeFire,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required IconData icon,
    required String label,
    required int index,
    required bool isFilled,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? AppColors.forgeFire : AppColors.gray400;

    return Expanded(
      child: MaterialInkWell(
        onTap: () => onTabSelected?.call(index),
        radius: 12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 26,
            ),
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.forgeFire : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.forgeFire.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTheme.caption.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
