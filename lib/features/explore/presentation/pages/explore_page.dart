import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../routing/routes.dart';
import '../../../learn/model/lesson.dart';
import '../../../learn/ui/state/learn_state.dart';
import '../../../learn/ui/view_model/learn_view_model.dart';

/// Searchable catalog with readable program previews and real prerequisites.
class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final learn = ref.watch(learnViewModelProvider);
    return FgImmersiveScaffold(
      bodyBuilder: (context) => learn.when(
        loading: () => const Center(child: FgSpinner()),
        error: (_, _) => FgEmpty(
          icon: Icons.error_outline,
          title: LocaleKeys.unexpectedErrorOccurred.tr(),
          tone: FgEmptyTone.error,
          actionLabel: LocaleKeys.programmesRetry.tr(),
          onAction: () => ref.invalidate(learnViewModelProvider),
        ),
        data: (state) => _buildContent(context, state),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LearnState state) {
    final sections = [
      for (final category in ModuleCategory.values)
        (
          category: category,
          modules: state.modules
              .where(
                (module) =>
                    module.category == category &&
                    (_query.isEmpty ||
                        module.title.toLowerCase().contains(_query) ||
                        module.tag.toLowerCase().contains(_query)),
              )
              .toList(),
        ),
    ].where((section) => section.modules.isNotEmpty).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppHeader(title: LocaleKeys.exploreTitle.tr()),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screen,
            child: FgSectionHeading(
              title: LocaleKeys.cypherLearnHeadline.tr(),
              subtitle: LocaleKeys.cypherLearnSubtitle.tr(),
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.screen,
          sliver: SliverToBoxAdapter(
            child: FgInput.search(
              controller: _searchController,
              placeholder: LocaleKeys.searchExploreHint.tr(),
              onClear: _searchController.clear,
              clearSemanticsLabel: LocaleKeys.clearSearch.tr(),
              showFilter: false,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                FgButton(
                  text: LocaleKeys.forgeProgrammes.tr(),
                  icon: const Icon(Icons.route_outlined),
                  variant: FgButtonVariant.ghost,
                  onPressed: () => context.push(Routes.programmes),
                ),
                FgButton(
                  text: LocaleKeys.lessonHistory.tr(),
                  icon: const Icon(Icons.history),
                  variant: FgButtonVariant.ghost,
                  onPressed: () => context.push(Routes.lessonHistory),
                ),
              ],
            ),
          ),
        ),
        if (sections.isEmpty)
          SliverToBoxAdapter(
            child: FgEmpty(
              icon: Icons.search_off,
              title: LocaleKeys.noResults.tr(),
              description: LocaleKeys.searchExploreHint.tr(),
            ),
          ),
        SliverList.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return Padding(
              padding: AppSpacing.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FgSectionHeading(title: _categoryLabel(section.category)),
                  const SizedBox(height: AppSpacing.lg),
                  FgProgramCardLayout(
                    children: [
                      for (final module in section.modules)
                        _moduleCard(context, state, module),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.bottomNavHeight + AppSpacing.xxl),
        ),
      ],
    );
  }

  String _categoryLabel(ModuleCategory category) => switch (category) {
    ModuleCategory.fundamentals => LocaleKeys.categoryFundamentals.tr(),
    ModuleCategory.streetStyles => LocaleKeys.categoryStreetStyles.tr(),
    ModuleCategory.choreography => LocaleKeys.categoryChoreography.tr(),
  };

  Widget _moduleCard(BuildContext context, LearnState state, Module module) {
    final locked = !state.isModuleUnlocked(module);
    final unmet = state.unmetPrerequisiteLessonIds(module);
    final requirement = unmet.isEmpty
        ? null
        : state.lessonById(unmet.first)?.title;
    return FgProgramCard(
      title: module.title,
      imageUrl: module.imageUrl,
      label: locked
          ? '${module.tag} • ${LocaleKeys.lockedLabel.tr()}'
          : module.tag,
      details: locked
          ? LocaleKeys.requiresLesson.tr(args: [requirement ?? '—'])
          : LocaleKeys.lessonsCompletedOf.tr(
              args: [
                '${state.completedCountIn(module)}',
                '${module.lessons.length}',
              ],
            ),
      locked: locked,
      actionLabel: LocaleKeys.vocabularyViewPath.tr(),
      progress: state.moduleProgressOf(module),
      onTap: () {
        ref.read(learnViewModelProvider.notifier).selectModule(module.id);
        ModuleDestination(module.id).push<void>(context);
      },
    );
  }
}
