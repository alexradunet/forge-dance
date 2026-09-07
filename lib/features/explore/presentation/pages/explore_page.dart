import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../design_system/molecules/cards/fg_program_card.dart';
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
  Widget build(BuildContext context) => Scaffold(
    body: FgBackground(
      child: ref
          .watch(learnViewModelProvider)
          .when(
            loading: () => const Center(child: FgSpinner()),
            error: (_, _) => FgEmpty(
              icon: Icons.error_outline,
              title: LocaleKeys.unexpectedErrorOccurred.tr(),
              tone: FgEmptyTone.error,
            ),
            data: _buildContent,
          ),
    ),
  );

  Widget _buildContent(LearnState state) {
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
          child: AppHeader(
            title: LocaleKeys.exploreTitle.tr(),
            subtitle: LocaleKeys.exploreSubtitle.tr(),
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
                  Text(
                    _categoryLabel(section.category),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).forgeColors.onImmersive,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FgProgramCardLayout(
                    children: [
                      for (final module in section.modules)
                        _moduleCard(state, module),
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

  Widget _moduleCard(LearnState state, Module module) {
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
      progress: state.moduleProgressOf(module),
      onTap: () {
        ref.read(learnViewModelProvider.notifier).selectModule(module.id);
        ModuleDestination(module.id).push<void>(context);
      },
    );
  }
}
