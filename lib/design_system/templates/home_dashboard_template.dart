import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Home dashboard template - Layout structure for home screen
class HomeDashboardTemplate extends StatelessWidget {
  final Widget? header;
  final Widget? featuredContent;
  final Widget? progressSection;
  final Widget? quickActions;
  final Widget? bottomNavigation;

  const HomeDashboardTemplate({
    super.key,
    this.header,
    this.featuredContent,
    this.progressSection,
    this.quickActions,
    this.bottomNavigation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray950,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Section
            if (header != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xxl,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                    AppSpacing.md,
                  ),
                  child: header!,
                ),
              ),

            // Featured Content
            if (featuredContent != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: featuredContent!,
                ),
              ),

            // Progress Section
            if (progressSection != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xxl,
                    AppSpacing.xxl,
                    AppSpacing.xxl,
                    AppSpacing.md,
                  ),
                  child: progressSection!,
                ),
              ),

            // Quick Actions
            if (quickActions != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xxl,
                    AppSpacing.md,
                    AppSpacing.xxl,
                    AppSpacing.xxl,
                  ),
                  child: quickActions!,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigation,
    );
  }
}
