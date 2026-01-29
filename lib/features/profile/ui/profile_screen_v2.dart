import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/constants/constants.dart';
import '/extensions/build_context_extension.dart';
import '/extensions/profile_extension.dart';
import '/generated/locale_keys.g.dart';
import '/routing/routes.dart';
import '/design_system/tokens/app_colors.dart';
import '/utils/global_loading.dart';
import '../../../../features/common/ui/widgets/common_dialog.dart';
import '../model/profile.dart';
import 'view_model/profile_view_model.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_stats.dart';
import 'widgets/achievements_carousel.dart';
import 'widgets/rewards_grid.dart';
import 'widgets/profile_menu.dart';

/// Redesigned Profile Screen matching dashboard_1 mockup
class ProfileScreenV2 extends ConsumerStatefulWidget {
  const ProfileScreenV2({super.key});

  @override
  ConsumerState createState() => _ProfileScreenV2State();
}

class _ProfileScreenV2State extends ConsumerState<ProfileScreenV2> {
  var _version = '';

  // Mock data - replace with actual data from backend
  final List<Achievement> _achievements = const [
    Achievement(name: 'Groove Master', icon: Icons.emoji_events, isUnlocked: true),
    Achievement(name: 'Perfect Week', icon: Icons.stars, isUnlocked: true),
    Achievement(name: 'Inferno Streak', icon: Icons.local_fire_department, isUnlocked: true),
    Achievement(name: 'Rhythm King', icon: Icons.music_note, isUnlocked: false),
  ];

  final List<RewardItem> _rewards = const [
    RewardItem(
      name: 'Neon Striders',
      category: 'Rare Footwear',
      icon: Icons.directions_walk,
      isNew: true,
    ),
    RewardItem(
      name: 'Forge Hoodie',
      category: 'Epic Upper',
      icon: Icons.checkroom,
      isNew: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final profile =
        ref.watch(profileViewModelProvider.select((it) => it.value?.profile));

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Background gradients
          _buildBackgroundGradients(),
          // Main content
          _buildMainContent(profile),
          // Bottom navigation (matching mockup)
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradients() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.forgeFire.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.electricBlue.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Profile? profile) {
    return CustomScrollView(
      slivers: [
        // Header with title and settings
        SliverToBoxAdapter(
          child: _buildHeader(),
        ),
        // Profile info
        SliverToBoxAdapter(
          child: _buildProfileInfo(profile),
        ),
        // Stats grid
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ProfileStatsRow(
              streak: 128,
              totalFP: '14k',
              rank: '#08',
            ),
          ),
        ),
        // Achievements carousel
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: AchievementsCarousel(
              achievements: _achievements,
              onViewAll: () {
                // TODO: Navigate to achievements page
              },
            ),
          ),
        ),
        // Recent rewards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: RewardsGrid(rewards: _rewards),
          ),
        ),
        // Settings sections
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: _buildSettingsMenu(profile),
          ),
        ),
        // Version info and spacing for bottom nav
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
            child: Center(
              child: Text(
                'Version $_version',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.paddingOf(context).top + 12,
        24,
        8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'PROFILE',
            style: TextStyle(
              fontFamily: 'Bebas Neue',
              fontSize: 42,
              color: Colors.white,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to settings
            },
            icon: Icon(
              Icons.settings,
              color: AppColors.textMuted,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(Profile? profile) {
    return Column(
      children: [
        const SizedBox(height: 24),
        ProfileAvatar(
          url: profile?.avatar,
          levelBadge: 'Legend',
          radius: 64,
        ),
        const SizedBox(height: 20),
        Text(
          profile?.name ?? 'Alex "Pulse" Chen',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Lvl 42 • Pro Dancer',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'JetBrains Mono',
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSettingsMenu(Profile? profile) {
    return Column(
      children: [
        ProfileMenuSection(
          title: 'General',
          items: [
            ProfileMenuItem(
              icon: Icons.person_outline,
              label: LocaleKeys.accountInformation.tr(),
              onTap: () => context.push(
                Routes.accountInformation,
                extra: profile ?? Profile(),
              ),
            ),
            ProfileMenuItem(
              icon: Icons.palette_outlined,
              label: LocaleKeys.appearances.tr(),
              onTap: () => context.push(Routes.appearances),
            ),
            ProfileMenuItem(
              icon: Icons.language,
              label: LocaleKeys.language.tr(),
              onTap: () => context.push(Routes.languages),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ProfileMenuSection(
          title: 'Support',
          items: [
            ProfileMenuItem(
              icon: Icons.article_outlined,
              label: LocaleKeys.termOfService.tr(),
              onTap: () => context.tryLaunchUrl(Constants.termOfService),
            ),
            ProfileMenuItem(
              icon: Icons.shield_outlined,
              label: LocaleKeys.privacyPolicy.tr(),
              onTap: () => context.tryLaunchUrl(Constants.privacyPolicy),
            ),
            ProfileMenuItem(
              icon: Icons.star_outline,
              label: LocaleKeys.rateUs.tr(),
              onTap: () => context.tryLaunchUrl(
                Platform.isIOS ? Constants.appStore : Constants.playStore,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ProfileMenuSection(
          title: 'Account',
          items: [
            ProfileMenuItem(
              icon: Icons.logout,
              label: LocaleKeys.logOut.tr(),
              textColor: AppColors.passionRed,
              showArrow: false,
              onTap: () => _signOut(context),
            ),
            ProfileMenuItem(
              icon: Icons.delete_outline,
              label: LocaleKeys.deleteAccount.tr(),
              textColor: AppColors.passionRed,
              showArrow: false,
              onTap: () => _deleteAccount(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            color: const Color(0xFF121212).withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, 'Home', false),
              _buildNavItem(Icons.explore, 'Explore', false),
              _buildIgniteButton(),
              _buildNavItem(Icons.bar_chart, 'Stats', false),
              _buildNavItem(Icons.person, 'Profile', true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 26,
          color: isActive ? AppColors.forgeFire : AppColors.textMuted,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppColors.forgeFire : AppColors.textMuted,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.forgeFire,
              boxShadow: [
                BoxShadow(
                  color: AppColors.forgeFire.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          )
        else
          const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildIgniteButton() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.forgeFire,
                  const Color(0xFFE03E00),
                ],
              ),
              border: Border.all(
                color: AppColors.bgDeep,
                width: 6,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.forgeFire.withOpacity(0.6),
                  blurRadius: 35,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.local_fire_department,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'IGNITE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.forgeFire,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _getPackageInfo() {
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _version = info.version;
      });
    }).catchError((error) {
      debugPrint(
          '${Constants.tag} [_ProfileScreenV2State._getPackageInfo] Error: $error');
    });
  }

  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CommonDialog(
        title: LocaleKeys.logOutTitle.tr(),
        content: LocaleKeys.logOutMessage.tr(),
        primaryButtonLabel: LocaleKeys.logOut.tr(),
        primaryButtonBackground: AppColors.passionRed,
        secondaryButtonLabel: LocaleKeys.cancel.tr(),
        primaryButtonAction: () async {
          try {
            Global.showLoading(context);
            await ref.read(profileViewModelProvider.notifier).signOut();
          } on AuthException catch (error) {
            if (context.mounted) {
              context.showErrorSnackBar(error.message);
            }
          } catch (error) {
            if (context.mounted) {
              context.showErrorSnackBar(LocaleKeys.unexpectedErrorOccurred.tr());
            }
          } finally {
            if (context.mounted) {
              Global.hideLoading();
              context.pushReplacement(Routes.register);
            }
          }
        },
      ),
    );
  }

  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CommonDialog(
        title: LocaleKeys.deleteAccountTitle.tr(),
        content: LocaleKeys.deleteAccountMessage.tr(),
        primaryButtonLabel: LocaleKeys.deleteAccount.tr(),
        primaryButtonBackground: AppColors.passionRed,
        secondaryButtonLabel: LocaleKeys.cancel.tr(),
        primaryButtonAction: () async {
          try {
            Global.showLoading(context);
            await ref.read(profileViewModelProvider.notifier).signOut();
          } on AuthException catch (error) {
            if (context.mounted) {
              context.showErrorSnackBar(error.message);
            }
          } catch (error) {
            if (context.mounted) {
              context.showErrorSnackBar(LocaleKeys.unexpectedErrorOccurred.tr());
            }
          } finally {
            if (context.mounted) {
              Global.hideLoading();
              context.pushReplacement(Routes.register);
            }
          }
        },
      ),
    );
  }
}
