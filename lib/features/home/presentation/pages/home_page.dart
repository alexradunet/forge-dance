import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/assets.dart';
import '../../../../routing/routes.dart';
import '../../../stats/model/user_stats.dart';
import '../../../movement_teacher/prototype/ui/motion_lab_page.dart';
import '../../../stats/ui/view_model/user_stats_provider.dart';
import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../learn/model/lesson.dart';
import '../../../learn/model/lesson_progress.dart';
import '../../../learn/ui/state/learn_state.dart';
import '../../../learn/ui/view_model/learn_view_model.dart';
import '../../../profile/ui/view_model/profile_view_model.dart';

/// Home combines assessed mastery, daily practice, and the existing curriculum.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learnState = ref.watch(learnViewModelProvider);

    return FgImmersiveScaffold(
      bodyBuilder: (context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.editorialContentMax,
          ),
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
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, LearnState state) {
    final profileName = ref
        .watch(profileViewModelProvider)
        .value
        ?.profile
        ?.name;
    final stats = ref.watch(userStatsProvider).value ?? const UserStats();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: AppHeader(
            title: _dancerHandle(profileName),
            subtitle: LocaleKeys.welcomeBack.tr(),
            compact: true,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: FgDanceHero(
              image: const AssetImage(Assets.cypherDancer),
              eyebrow: LocaleKeys.cypherEyebrow.tr(),
              title: LocaleKeys.cypherHeadline.tr(),
              subtitle: LocaleKeys.cypherInvitation.tr(),
              action: FgButton(
                text: LocaleKeys.forgeTodayPractice.tr(),
                icon: const Icon(Icons.north_east),
                size: FgButtonSize.lg,
                expand: true,
                onPressed: () => context.push(Routes.practice),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.allLG,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    FgButton(
                      text: LocaleKeys.forgeAssessments.tr(),
                      variant: FgButtonVariant.ghost,
                      onPressed: () => context.push(Routes.method),
                    ),
                    FgButton(
                      text: LocaleKeys.forgeProgrammes.tr(),
                      variant: FgButtonVariant.ghost,
                      onPressed: () => context.push(Routes.programmes),
                    ),
                    FgButton(
                      text: LocaleKeys.forgeLogbook.tr(),
                      icon: const Icon(Icons.history),
                      variant: FgButtonVariant.ghost,
                      onPressed: () => context.push(Routes.practiceLog),
                    ),
                  ],
                ),
                FgDetails(
                  key: const ValueKey('home-forge-explanation'),
                  title: LocaleKeys.detailsLearnMore.tr(),
                  child: Text(LocaleKeys.forgeCoreSubtitle.tr()),
                ),
                if (kDebugMode)
                  FgButton(
                    text: LocaleKeys.motionLabOpen.tr(),
                    icon: const Icon(Icons.view_in_ar),
                    variant: FgButtonVariant.secondary,
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).push<void>(
                          MaterialPageRoute(
                            builder: (_) => const MotionLabPage(),
                          ),
                        ),
                  ),
              ],
            ),
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
        SliverToBoxAdapter(child: _buildProgressSection(context, stats)),

        // Continue Training — every module the user is partway through
        if (state.inProgressModules.isNotEmpty)
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
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
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
      args: ['${state.completedCountIn(module)}', '${module.lessons.length}'],
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

    final subtitle = lesson == null
        ? LocaleKeys.moduleCompleteSubtitle.tr()
        : lesson.duration.isEmpty
        ? state.activeModule.title
        : '${state.activeModule.title} • ${lesson.duration}';

    return FgRoundPanel(
      label: LocaleKeys.continueTraining.tr().toUpperCase(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FgSectionHeading(
            title:
                lesson?.title.toUpperCase() ??
                LocaleKeys.moduleComplete.tr().toUpperCase(),
            subtitle: subtitle,
          ),
          const SizedBox(height: AppSpacing.lg),
          FgButton(
            text: lesson == null
                ? LocaleKeys.replayLessons.tr()
                : state.statusOf(lesson) == LessonStatus.inProgress
                ? LocaleKeys.continueLesson.tr()
                : LocaleKeys.startLesson.tr(),
            variant: FgButtonVariant.secondary,
            onPressed: lesson == null
                ? () =>
                      ModuleDestination(state.activeModule.id)
                          .push<void>(context)
                : () => _startCurrentLesson(context, ref, state, lesson),
          ),
        ],
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

  Widget _buildProgressSection(BuildContext context, UserStats stats) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: FgProgressSection(
        immersive: true,
        title: LocaleKeys.myProgress.tr().toUpperCase(),
        stats: const [],
        levelProgress: FgProgressData(
          label:
              '${LocaleKeys.levelLabel.tr(args: ['${stats.level}'])} • '
              '${LocaleKeys.beltNameLabel.tr(args: [stats.beltName])}',
          current: stats.levelProgress,
          target: 1,
          valueLabel: stats.nextBeltName == null
              ? LocaleKeys.maxLevelReached.tr()
              : LocaleKeys.forgeNextBelt.tr(args: [stats.nextBeltName!]),
          message:
              '${LocaleKeys.currentStreak.tr()}: '
              '${LocaleKeys.dayN.tr(args: ['${stats.streakCount}'])}',
        ),
        onProgressTap: () => context.push(Routes.method),
      ),
    );
  }

  Widget _buildHorizontalSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    bool showViewAll = false,
  }) {
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
              Expanded(child: FgSectionHeading(title: title)),
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
