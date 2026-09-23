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

/// Photo-led discovery with real learning/progress, never fabricated activity.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learnState = ref.watch(learnViewModelProvider);
    final profileName = ref
        .watch(profileViewModelProvider)
        .value
        ?.profile
        ?.name;
    final stats = ref.watch(userStatsProvider).value ?? const UserStats();
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
            data: (state) =>
                _buildContent(context, ref, state, profileName, stats),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    LearnState state,
    String? profileName,
    UserStats stats,
  ) {
    // The active module already has the prominent continue card below.
    final otherInProgress = state.inProgressModules
        .where((module) => module.id != state.activeModule.id)
        .toList();
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
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
              key: const ValueKey('home-photo-hero'),
              image: const AssetImage(Assets.cypherDancer),
              imageLabel: LocaleKeys.photoPreviewLabel.tr(),
              eyebrow: LocaleKeys.cypherEyebrow.tr(),
              title: LocaleKeys.photoHomeHeadline.tr(),
              subtitle: LocaleKeys.photoHomeInvitation.tr(),
              action: FgButton(
                text: LocaleKeys.forgeTodayPractice.tr(),
                icon: const Icon(Icons.north_east),
                expand: true,
                onPressed: () => context.push(Routes.practice),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.allLG,
          sliver: SliverToBoxAdapter(
            child: _buildDailySessionCard(context, ref, state),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.allLG,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FgSectionHeading(title: LocaleKeys.photoDiscoverHeading.tr()),
                const SizedBox(height: AppSpacing.lg),
                FgPhotoTileLayout(
                  children: [
                    FgPhotoTile(
                      key: const ValueKey('home-learn-photo'),
                      image: const AssetImage(Assets.studioDancerPreview),
                      label: LocaleKeys.exploreTitle.tr(),
                      title: LocaleKeys.photoLearnTitle.tr(),
                      onTap: () => MainTabDestination.explore.go(context),
                    ),
                    FgPhotoTile(
                      key: const ValueKey('home-programmes-photo'),
                      image: const AssetImage(Assets.danceFloorPreview),
                      label: LocaleKeys.forgeProgrammes.tr(),
                      title: LocaleKeys.photoProgrammesTitle.tr(),
                      onTap: () => context.push(Routes.programmes),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: _buildProgressSection(context, stats)),
        if (otherInProgress.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildModuleSection(
              context,
              ref,
              state,
              LocaleKeys.continueTraining.tr(),
              otherInProgress,
            ),
          ),
        if (state.recommendedModules.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildModuleSection(
              context,
              ref,
              state,
              LocaleKeys.recommendedForYou.tr(),
              state.recommendedModules,
            ),
          ),
        SliverPadding(
          padding: AppSpacing.allLG,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(LocaleKeys.cypherInvitation.tr()),
                      const SizedBox(height: AppSpacing.sm),
                      Text(LocaleKeys.forgeCoreSubtitle.tr()),
                      if (kDebugMode)
                        FgButton(
                          text: LocaleKeys.motionLabOpen.tr(),
                          icon: const Icon(Icons.view_in_ar),
                          variant: FgButtonVariant.secondary,
                          onPressed: () =>
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).push<void>(
                                MaterialPageRoute(
                                  builder: (_) => const MotionLabPage(),
                                ),
                              ),
                        ),
                    ],
                  ),
                ),
                FgDetails(
                  title: LocaleKeys.photoAboutTitle.tr(),
                  child: Text(LocaleKeys.photoAboutBody.tr()),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }

  String _dancerHandle(String? name) {
    final source = (name == null || name.trim().isEmpty)
        ? Constants.defaultName
        : name.trim();
    return source.toUpperCase().replaceAll(RegExp(r'\s+'), '_');
  }

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
          FgPhotoHeading(
            image: const AssetImage(Assets.studioDancerPreview),
            imageLabel: LocaleKeys.photoPreviewLabel.tr(),
            title: lesson?.title ?? LocaleKeys.moduleComplete.tr(),
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

  Widget _buildModuleSection(
    BuildContext context,
    WidgetRef ref,
    LearnState state,
    String title,
    List<Module> modules,
  ) => Padding(
    padding: AppSpacing.allLG,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FgSectionHeading(title: title),
        const SizedBox(height: AppSpacing.lg),
        FgProgramCardLayout(
          children: [
            for (final module in modules)
              FgProgramCard(
                title: module.title,
                label: '${module.tag} • ${LocaleKeys.photoPreviewLabel.tr()}',
                image: AssetImage(
                  Assets.practicePreviewPhotos[module.category.index %
                      Assets.practicePreviewPhotos.length],
                ),
                progress: state.moduleProgressOf(module),
                details: LocaleKeys.lessonsCompletedOf.tr(
                  args: [
                    '${state.completedCountIn(module)}',
                    '${module.lessons.length}',
                  ],
                ),
                actionLabel: LocaleKeys.vocabularyViewPath.tr(),
                onTap: () {
                  ref
                      .read(learnViewModelProvider.notifier)
                      .selectModule(module.id);
                  ModuleDestination(module.id).push<void>(context);
                },
              ),
          ],
        ),
      ],
    ),
  );

  Widget _buildProgressSection(
    BuildContext context,
    UserStats stats,
  ) => Padding(
    padding: AppSpacing.allLG,
    child: FgProgressSection(
      immersive: true,
      title: LocaleKeys.myProgress.tr().toUpperCase(),
      stats: const [],
      levelProgress: FgProgressData(
        label:
            '${LocaleKeys.levelLabel.tr(args: ['${stats.level}'])} • ${LocaleKeys.beltNameLabel.tr(args: [stats.beltName])}',
        current: stats.levelProgress,
        target: 1,
        valueLabel: stats.nextBeltName == null
            ? LocaleKeys.maxLevelReached.tr()
            : LocaleKeys.forgeNextBelt.tr(args: [stats.nextBeltName!]),
        message:
            '${LocaleKeys.currentStreak.tr()}: ${LocaleKeys.dayN.tr(args: ['${stats.streakCount}'])}',
      ),
      onProgressTap: () => context.push(Routes.method),
    ),
  );
}
