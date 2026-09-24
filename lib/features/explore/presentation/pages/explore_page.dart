import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../routing/routes.dart';
import '../../../learn/model/lesson.dart';
import '../../../learn/repository/learning_catalogue.dart';
import '../../../programmes/repository/programme_catalog.dart';
import '../../../programmes/ui/programmes_page.dart';
import '../../../programmes/ui/programmes_view_model.dart';
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
    final catalogue = learningCatalogue(_query, state.modules);
    final enrolled = ref.watch(programmesViewModelProvider);

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
                if (kDebugMode)
                  FgButton(
                    text: 'Preview roadmap',
                    icon: const Icon(Icons.account_tree_outlined),
                    variant: FgButtonVariant.ghost,
                    onPressed: () =>
                        context.go('${Routes.explore}?variant=roadmap'),
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
        if (catalogue.modules.isEmpty && catalogue.programmes.isEmpty)
          SliverToBoxAdapter(
            child: FgEmpty(
              icon: Icons.search_off,
              title: LocaleKeys.noResults.tr(),
              description: LocaleKeys.searchExploreHint.tr(),
            ),
          ),
        SliverPadding(
          padding: AppSpacing.screen,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FgSectionHeading(title: LocaleKeys.learningPaths.tr()),
                const SizedBox(height: AppSpacing.lg),
                if (enrolled.isLoading) const Center(child: FgSpinner()),
                if (enrolled.hasError)
                  FgEmpty(
                    icon: Icons.error_outline,
                    title: LocaleKeys.learningPathsLoadError.tr(),
                    actionLabel: LocaleKeys.programmesRetry.tr(),
                    onAction: () => ref.invalidate(programmesViewModelProvider),
                  ),
                FgProgramCardLayout(
                  children: [
                    if (enrolled.hasValue)
                      for (final programme in catalogue.programmes)
                        ProgrammePathCard(
                          programme: programme,
                          index: forgeProgrammes.indexOf(programme),
                          learn: state,
                          enrolled: enrolled.value!.contains(programme.id),
                        ),
                    for (final module in catalogue.modules)
                      _moduleCard(context, state, module),
                  ],
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
