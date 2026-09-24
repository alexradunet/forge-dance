import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../routing/routes.dart';
import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../method/model/forge_method.dart';
import '../../../method/ui/method_view_model.dart';
import '../../../stats/model/user_stats.dart';
import '../../../stats/ui/view_model/user_stats_provider.dart';
import '../../model/profile.dart';
import '../../ui/view_model/profile_view_model.dart';
import '../../ui/widgets/level_grid.dart';
import '../../ui/widgets/profile_menu.dart';
import '../../model/level_model.dart';
import '../pages/level_progression_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  void _openLevelProgression(
    BuildContext context,
    List<DanceLevel> levels, {
    int? levelId,
  }) {
    int initialIndex;
    if (levelId != null) {
      initialIndex = levels.indexWhere((l) => l.id == levelId);
    } else {
      initialIndex = levels.indexWhere((l) => l.isCurrent);
    }
    if (initialIndex == -1) initialIndex = 0;

    ForgeBottomSheet.showPage<void>(
      context: context,
      child: LevelProgressionPage(initialLevelIndex: initialIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileViewModelProvider);
    final stats = ref.watch(userStatsProvider);
    final mastery = ref.watch(methodViewModelProvider);

    return FgImmersiveScaffold(
      bodyBuilder: (context) => FgReadingBody(
        child: profile.hasError || stats.hasError || mastery.hasError
            ? SingleChildScrollView(
                child: FgEmpty(
                  icon: Icons.error_outline,
                  title: LocaleKeys.unexpectedErrorOccurred.tr(),
                  tone: FgEmptyTone.error,
                  actionLabel: LocaleKeys.practiceRetry.tr(),
                  onAction: () {
                    ref.invalidate(profileViewModelProvider);
                    ref.invalidate(methodViewModelProvider);
                    ref.invalidate(userStatsProvider);
                  },
                ),
              )
            : !profile.hasValue || !stats.hasValue || !mastery.hasValue
            ? const Center(child: FgSpinner())
            : _buildMainContent(
                context,
                profile.value!.profile,
                stats.value!,
                mastery.value!,
              ),
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    Profile? profile,
    UserStats stats,
    MethodProgress mastery,
  ) {
    final levels = DanceLevel.buildAll(progress: mastery);
    final levelSubtitle = LocaleKeys.levelBeltSubtitle.tr(
      args: ['${stats.level}', stats.beltName],
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppHeader(
            title: LocaleKeys.profileTitle.tr().toUpperCase(),
            subtitle: levelSubtitle,
            rightSlot: FgIconButton(
              icon: Icons.settings_rounded,
              semanticLabel: LocaleKeys.settings.tr(),
              onPressed: () => context.push(Routes.settings),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildProfileInfo(context, profile, stats, levelSubtitle),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screen,
            child: FgProgressSection(
              immersive: true,
              editorial: true,
              title: LocaleKeys.myProgress.tr().toUpperCase(),
              stats: [
                FgStatData(
                  label: LocaleKeys.currentStreak.tr(),
                  value: LocaleKeys.dayN.tr(args: ['${stats.streakCount}']),
                  icon: Icons.local_fire_department_rounded,
                ),
                FgStatData(
                  label: LocaleKeys.totalXpLabel.tr(),
                  value: LocaleKeys.xpValue.tr(args: ['${stats.totalXp}']),
                  icon: Icons.workspace_premium_rounded,
                ),
              ],
              levelProgress: FgProgressData(
                label: levelSubtitle,
                current: stats.levelProgress,
                target: 1,
                valueLabel: stats.nextBeltName == null
                    ? LocaleKeys.maxLevelReached.tr()
                    : LocaleKeys.forgeNextBelt.tr(args: [stats.nextBeltName!]),
                message: LocaleKeys.forgeXpSeparate.tr(),
              ),
              onProgressTap: () => _openLevelProgression(context, levels),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.sm,
            ),
            child: FgButton(
              text: LocaleKeys.skillMastery.tr().toUpperCase(),
              icon: const Icon(Icons.chevron_right_rounded),
              variant: FgButtonVariant.ghost,
              expand: true,
              onPressed: () => _openLevelProgression(context, levels),
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.horizontalXXL,
          sliver: SliverToBoxAdapter(
            child: FgButton(
              text: LocaleKeys.forgeAssessments.tr(),
              expand: true,
              onPressed: () => context.push(Routes.method),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: LevelGrid(
            levels: levels,
            onLevelTap: (level) =>
                _openLevelProgression(context, levels, levelId: level.id),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.allXXL,
          sliver: SliverToBoxAdapter(
            child: ProfileMenuSection(
              title: LocaleKeys.general.tr(),
              items: [
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  label: LocaleKeys.accountInformation.tr(),
                  onTap: () => context.push(
                    Routes.accountInformation,
                    extra: profile ?? const Profile(),
                  ),
                ),
                ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  label: LocaleKeys.settings.tr(),
                  onTap: () => context.push(Routes.settings),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.bottomNavHeight + AppSpacing.xxl),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(
    BuildContext context,
    Profile? profile,
    UserStats stats,
    String levelSubtitle,
  ) {
    final avatar = FgAvatar.large(
      imageUrl: profile?.avatar,
      initials: profile?.name?.trim().isNotEmpty == true
          ? profile!.name!.trim().characters.first
          : null,
      level: stats.level,
      tone: FgAvatarTone.reward,
      semanticLabel: profile?.name ?? Constants.defaultName,
    );
    final identity = FgSectionHeading(
      eyebrow: LocaleKeys.personalLocalIdentity.tr(),
      title: profile?.name ?? Constants.defaultName,
      subtitle: levelSubtitle,
    );
    return Padding(
      padding: AppSpacing.horizontalXXL,
      child: FgCard(
        immersive: true,
        shape: FgCardShape.editorial,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < AppSizes.cardStandardWidth ||
                MediaQuery.textScalerOf(context).scale(1) > 1.5) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  avatar,
                  const SizedBox(height: AppSpacing.lg),
                  identity,
                ],
              );
            }
            return Row(
              children: [
                avatar,
                const SizedBox(width: AppSpacing.lg),
                Expanded(child: identity),
              ],
            );
          },
        ),
      ),
    );
  }
}
