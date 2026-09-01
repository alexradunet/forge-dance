import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../routing/routes.dart';
import '../../../stats/model/user_stats.dart';
import '../../../stats/ui/view_model/user_stats_provider.dart';
import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../learn/model/lesson.dart';
import '../../../learn/ui/state/learn_state.dart';
import '../../../learn/ui/view_model/learn_view_model.dart';
import '../../../profile/ui/view_model/profile_view_model.dart';

/// Home dashboard. Header, daily session hero, progress card, and the
/// continue-training rail derive from real data (profile + lesson progress).
/// The recommended rail is still mock discovery content.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learnState = ref.watch(learnViewModelProvider);

    return Scaffold(
      body: FgBackground(
        child: learnState.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, _) => FgEmpty(
            icon: Icons.error_outline,
            title: LocaleKeys.unexpectedErrorOccurred.tr(),
            tone: FgEmptyTone.error,
          ),
          data: (state) => _buildContent(context, ref, state),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, LearnState state) {
    final profileName =
        ref.watch(profileViewModelProvider).value?.profile?.name;
    final stats = ref.watch(userStatsProvider).value ?? const UserStats();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: AppHeader(
            title: _dancerHandle(profileName),
            subtitle: LocaleKeys.welcomeBack.tr(),
            rightSlot: _buildNotificationToggle(),
          ),
        ),

        // Daily session hero — the user's current lesson on the path
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.sm,
            ),
            child: _buildDailySessionCard(context, ref, state),
          ),
        ),

        // Progress Section (streak / level / XP — taps through to stats)
        SliverToBoxAdapter(
          child: _buildProgressSection(context, stats),
        ),

        // Continue Training — every module the user is partway through
        SliverToBoxAdapter(
          child: _buildHorizontalSection(
            context: context,
            title: LocaleKeys.continueTraining.tr().toUpperCase(),
            children: _interleave([
              for (final module in state.inProgressModules)
                _moduleCard(context, ref, state, module),
            ]),
          ),
        ),

        // Recommended — untouched modules from the catalog
        if (state.recommendedModules.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildHorizontalSection(
              context: context,
              title: LocaleKeys.recommendedForYou.tr().toUpperCase(),
              showViewAll: true,
              children: _interleave([
                for (final module in state.recommendedModules)
                  _moduleCard(
                    context,
                    ref,
                    state,
                    module,
                    width: AppSizes.cardCompactWidth,
                  ),
              ]),
            ),
          ),

        // Bottom Spacing for BottomNav
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSizes.bottomNavHeight + AppSpacing.xxl,
          ),
        ),
      ],
    );
  }

  /// FORGE_DANCER-style handle derived from the profile name.
  String _dancerHandle(String? name) {
    final source = (name == null || name.trim().isEmpty)
        ? Constants.defaultName
        : name.trim();
    return source.toUpperCase().replaceAll(RegExp(r'\s+'), '_');
  }

  String _lessonsCompletedLabel(LearnState state, Module module) {
    return LocaleKeys.lessonsCompletedOf.tr(
      args: [
        '${state.completedCountIn(module)}',
        '${module.lessons.length}',
      ],
    );
  }

  Widget _moduleCard(
    BuildContext context,
    WidgetRef ref,
    LearnState state,
    Module module, {
    double? width,
  }) {
    return FgContentCard(
      title: module.title,
      tags: [module.tag.toUpperCase()],
      imageUrl: module.imageUrl,
      progress: state.moduleProgressOf(module),
      footerLabel: _lessonsCompletedLabel(state, module),
      width: width,
      onTap: () => _openModule(context, ref, module),
    );
  }

  void _openModule(BuildContext context, WidgetRef ref, Module module) {
    ref.read(learnViewModelProvider.notifier).selectModule(module.id);
    ModuleDestination(module.id).push<void>(context);
  }

  List<Widget> _interleave(List<Widget> cards) => [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.lg),
          cards[i],
        ],
      ];

  Widget _buildDailySessionCard(
    BuildContext context,
    WidgetRef ref,
    LearnState state,
  ) {
    final lesson = state.currentLesson;

    if (lesson == null) {
      // Every lesson completed — celebrate and offer replay.
      return FgContentCard.hero(
        title: LocaleKeys.moduleComplete.tr().toUpperCase(),
        subtitle: LocaleKeys.moduleCompleteSubtitle.tr(),
        tags: [state.activeModule.title.toUpperCase()],
        imageUrl: state.activeModule.imageUrl,
        onTap: () =>
            ModuleDestination(state.activeModule.id).push<void>(context),
        action: FgButton(
          text: LocaleKeys.replayLessons.tr(),
          variant: FgButtonVariant.primary,
          size: FgButtonSize.lg,
          onPressed: () =>
              ModuleDestination(state.activeModule.id).push<void>(context),
        ),
      );
    }

    final subtitle = lesson.duration.isEmpty
        ? state.activeModule.title
        : '${state.activeModule.title} • ${lesson.duration}';

    return FgContentCard.hero(
      title: lesson.title.toUpperCase(),
      subtitle: subtitle,
      tags: [
        LocaleKeys.todaysSession.tr().toUpperCase(),
        lesson.type.label.toUpperCase(),
      ],
      imageUrl: state.activeModule.imageUrl,
      onTap: () => _startCurrentLesson(context, ref, state, lesson),
      action: FgButton(
        text: LocaleKeys.startLesson.tr(),
        variant: FgButtonVariant.primary,
        size: FgButtonSize.lg,
        onPressed: () => _startCurrentLesson(context, ref, state, lesson),
      ),
    );
  }

  void _startCurrentLesson(
    BuildContext context,
    WidgetRef ref,
    LearnState state,
    Lesson lesson,
  ) {
    ref.read(learnViewModelProvider.notifier).startLesson(lesson.id);
    LessonDestination(state.activeModule.id, lesson.id).push<void>(context);
  }

  Widget _buildNotificationToggle() {
    return const ExcludeSemantics(
      child: FgIcon(
        icon: Icons.notifications_none_rounded,
        size: AppSizes.iconLg,
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, UserStats stats) {
    final nextLevelTarget = stats.nextLevelXp?.toDouble();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: FgProgressSection(
        title: LocaleKeys.myProgress.tr().toUpperCase(),
        stats: [
          FgStatData(
            label: LocaleKeys.currentStreak.tr().toUpperCase(),
            value: LocaleKeys.dayN.tr(args: ['${stats.streakCount}']),
            icon: Icons.local_fire_department_rounded,
            tone: FgStatTone.primary,
          ),
          FgStatData(
            label: LocaleKeys.beltNameLabel
                .tr(args: [stats.beltName])
                .toUpperCase(),
            value: LocaleKeys.levelLabel.tr(args: ['${stats.level}']),
            icon: Icons.workspace_premium_rounded,
            tone: FgStatTone.reward,
          ),
        ],
        levelProgress: FgProgressData(
          label: LocaleKeys.beltNameLabel.tr(args: [stats.beltName]),
          current: stats.totalXp.toDouble(),
          target: nextLevelTarget ?? stats.totalXp.toDouble(),
          valueLabel: nextLevelTarget == null
              ? LocaleKeys.maxLevelReached.tr()
              : LocaleKeys.nextLevelXp.tr(args: ['${stats.nextLevelXp}']),
          message: LocaleKeys.xpValue.tr(args: ['${stats.totalXp}']),
        ),
        onProgressTap: () => context.push(Routes.stats),
      ),
    );
  }

  Widget _buildHorizontalSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    bool showViewAll = false,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: theme.textTheme.titleLarge),
              ),
              if (showViewAll)
                FgButton(
                  text: LocaleKeys.viewAll.tr().toUpperCase(),
                  variant: FgButtonVariant.ghost,
                  size: FgButtonSize.sm,
                  onPressed: () => MainTabDestination.explore.go(context),
                ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          physics: const BouncingScrollPhysics(),
          child: Row(children: children),
        ),
      ],
    );
  }
}
