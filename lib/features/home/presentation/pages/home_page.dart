import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/constants.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/atoms/progress/fg_progress_bar.dart';
import '../../../../design_system/atoms/progress/fg_spinner.dart';
import '../../../../design_system/atoms/icons/fg_icon.dart';
import '../../../../design_system/molecules/cards/fg_content_card.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/tokens/app_shadows.dart';
import '../../../../design_system/atoms/buttons/fg_button.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/ui/widgets/common_error.dart';
import '../../../learn/model/lesson.dart';
import '../../../learn/ui/state/learn_state.dart';
import '../../../learn/ui/view_model/learn_view_model.dart';
import '../../../profile/ui/view_model/profile_view_model.dart';

/// Home dashboard. Header, daily session hero, progress card, and the
/// continue-training rail derive from real data (profile + lesson progress).
/// The recommended rail is still mock discovery content.
class HomePage extends ConsumerWidget {
  final Function(String)? onNavigate;

  const HomePage({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learnState = ref.watch(learnViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by FgBackground
      body: FgBackground(
        child: learnState.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, __) => const CommonError(),
          data: (state) => _buildContent(context, ref, state),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, LearnState state) {
    final profileName =
        ref.watch(profileViewModelProvider).valueOrNull?.profile?.name;

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: _buildDailySessionCard(ref, state),
          ),
        ),

        // Progress Section
        SliverToBoxAdapter(
          child: _buildProgressSection(state),
        ),

        // Continue Training — every module the user is partway through
        SliverToBoxAdapter(
          child: _buildHorizontalSection(
            title: LocaleKeys.continueTraining.tr().toUpperCase(),
            children: _interleave([
              for (final module in state.inProgressModules)
                _moduleCard(ref, state, module),
            ]),
          ),
        ),

        // Recommended — untouched modules from the catalog
        if (state.recommendedModules.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildHorizontalSection(
              title: LocaleKeys.recommendedForYou.tr().toUpperCase(),
              showViewAll: true,
              children: _interleave([
                for (final module in state.recommendedModules)
                  _moduleCard(ref, state, module, width: 180),
              ]),
            ),
          ),

        // Bottom Spacing for BottomNav
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
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

  String _moduleTag(Module module) =>
      module.subtitle.split(' • ').first.toUpperCase();

  String _lessonsCompletedLabel(LearnState state, Module module) {
    return LocaleKeys.lessonsCompletedOf.tr(
      args: [
        '${state.completedCountIn(module)}',
        '${module.lessons.length}',
      ],
    );
  }

  Widget _moduleCard(
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
      onTap: () => _openModule(ref, module),
    );
  }

  void _openModule(WidgetRef ref, Module module) {
    ref.read(learnViewModelProvider.notifier).selectModule(module.id);
    onNavigate?.call('lesson-path');
  }

  List<Widget> _interleave(List<Widget> cards) => [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          cards[i],
        ],
      ];

  Widget _buildDailySessionCard(WidgetRef ref, LearnState state) {
    final lesson = state.currentLesson;

    if (lesson == null) {
      // Every lesson completed — celebrate and offer replay.
      return FgContentCard.hero(
        title: LocaleKeys.moduleComplete.tr().toUpperCase(),
        subtitle: LocaleKeys.moduleCompleteSubtitle.tr(),
        tags: [state.activeModule.title.toUpperCase()],
        imageUrl: state.activeModule.imageUrl,
        onTap: () => onNavigate?.call('lesson-path'),
        action: FgButton(
          text: LocaleKeys.replayLessons.tr(),
          variant: FgButtonVariant.primary,
          size: FgButtonSize.lg,
          onPressed: () => onNavigate?.call('lesson-path'),
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
      onTap: () => _startCurrentLesson(ref, lesson),
      action: FgButton(
        text: LocaleKeys.startLesson.tr(),
        variant: FgButtonVariant.primary,
        size: FgButtonSize.lg,
        onPressed: () => _startCurrentLesson(ref, lesson),
      ),
    );
  }

  void _startCurrentLesson(WidgetRef ref, Lesson lesson) {
    ref.read(learnViewModelProvider.notifier).startLesson(lesson.id);
    onNavigate?.call('lesson-player');
  }

  Widget _buildNotificationToggle() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const FgIcon(
              icon: Icons.notifications_none, size: 20, color: Colors.white),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.forgeFire,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgDeep, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(LearnState state) {
    final current = state.currentLesson;
    final percent = (state.moduleProgress * 100).round();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.myProgress.tr().toUpperCase(),
            style: AppTypography.h3
                .copyWith(color: AppColors.textMain, fontSize: 20),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [AppShadows.shadowCard],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.05)),
                          ),
                          child: const FgIcon(
                            icon: Icons.local_fire_department,
                            color: AppColors.forgeFire,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$percent%',
                                style: AppTypography.body
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Text(
                                LocaleKeys.moduleProgress.tr().toUpperCase(),
                                style: AppTypography.label.copyWith(
                                    color: AppColors.textMuted, fontSize: 9)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_moduleTag(state.activeModule),
                            style: AppTypography.body
                                .copyWith(fontWeight: FontWeight.bold)),
                        Text(state.activeModule.title.toUpperCase(),
                            style: AppTypography.label.copyWith(
                                color: AppColors.textMuted, fontSize: 9)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FgProgressBar(value: state.moduleProgress, height: 10),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        _lessonsCompletedLabel(state, state.activeModule)
                            .toUpperCase(),
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMuted)),
                    Text(
                        current == null
                            ? LocaleKeys.moduleComplete.tr().toUpperCase()
                            : LocaleKeys.nextUp
                                .tr(args: [current.title]).toUpperCase(),
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalSection({
    required String title,
    required List<Widget> children,
    bool showViewAll = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.h3
                    .copyWith(color: AppColors.textMain, fontSize: 20),
              ),
              if (showViewAll)
                GestureDetector(
                  onTap: () => onNavigate?.call('explore'),
                  child: Text(
                    LocaleKeys.viewAll.tr().toUpperCase(),
                    style: AppTypography.label.copyWith(
                      color: AppColors.forgeFire,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          child: Row(children: children),
        ),
      ],
    );
  }
}
