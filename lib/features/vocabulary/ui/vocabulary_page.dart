import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/assets.dart';
import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../model/vocabulary_entry.dart';
import '../repository/vocabulary_repository.dart';
import 'vocabulary_view_model.dart';

String vocabularyKindLabel(VocabularyKind kind) => switch (kind) {
  VocabularyKind.move => LocaleKeys.vocabularyMoves.tr(),
  VocabularyKind.concept => LocaleKeys.vocabularyConcepts.tr(),
};

class VocabularyPage extends ConsumerStatefulWidget {
  const VocabularyPage({super.key});

  @override
  ConsumerState<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends ConsumerState<VocabularyPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reset() {
    _searchController.clear();
    ref.read(vocabularyViewModelProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(vocabularyViewModelProvider);
    final entries = ref.watch(vocabularyResultsProvider);
    final introduced = ref.watch(vocabularyIntroducedIdsProvider);
    final notifier = ref.read(vocabularyViewModelProvider.notifier);
    const repository = VocabularyRepository();
    return FgImmersiveScaffold(
      bodyBuilder: (context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.editorialContentMax,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppHeader(title: LocaleKeys.vocabularyTitle.tr()),
              ),
              SliverPadding(
                padding: AppSpacing.allLG,
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FgPhotoHeading(
                        image: const AssetImage(Assets.danceFloorPreview),
                        imageLabel: LocaleKeys.photoPreviewLabel.tr(),
                        title: LocaleKeys.vocabularyHeadline.tr(),
                        subtitle: LocaleKeys.vocabularySubtitle.tr(),
                        editorial: true,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      FgInput.search(
                        controller: _searchController,
                        placeholder: LocaleKeys.vocabularySearch.tr(),
                        onChanged: notifier.search,
                        onClear: () {
                          _searchController.clear();
                          notifier.search('');
                        },
                        clearSemanticsLabel: LocaleKeys.clearSearch.tr(),
                        showFilter: false,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FgDetails(
                        key: const ValueKey('vocabulary-filters'),
                        title: LocaleKeys.vocabularyFilters.tr(
                          args: [
                            filters.hasSelections
                                ? [
                                    for (final kind in VocabularyKind.values)
                                      if (filters.kinds.contains(kind))
                                        vocabularyKindLabel(kind),
                                    for (final style in repository.styles)
                                      if (filters.styles.contains(style)) style,
                                  ].join(' · ')
                                : LocaleKeys.vocabularyAll.tr(),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LocaleKeys.vocabularyFilterHelp.tr()),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              LocaleKeys.vocabularyFilterType.tr(),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: [
                                for (final kind in VocabularyKind.values)
                                  FgFilterChip(
                                    label: vocabularyKindLabel(kind),
                                    isSelected: filters.kinds.contains(kind),
                                    onSelected: (_) =>
                                        notifier.toggleKind(kind),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              LocaleKeys.vocabularyFilterStyle.tr(),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: [
                                for (final style in repository.styles)
                                  FgFilterChip(
                                    label: style,
                                    isSelected: filters.styles.contains(style),
                                    onSelected: (_) =>
                                        notifier.toggleStyle(style),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (filters.hasSelections)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: FgButton(
                            text: LocaleKeys.vocabularyClearFilters.tr(),
                            variant: FgButtonVariant.ghost,
                            onPressed: notifier.clearFilters,
                          ),
                        ),
                      if (filters.query.isNotEmpty)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: FgButton(
                            text: LocaleKeys.vocabularyResetFilters.tr(),
                            variant: FgButtonVariant.ghost,
                            icon: const Icon(Icons.refresh),
                            onPressed: _reset,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        LocaleKeys.vocabularyIndex.tr(
                          args: ['${entries.length}'],
                        ),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ),
              if (entries.isEmpty)
                SliverToBoxAdapter(
                  child: FgEmpty(
                    icon: Icons.search_off,
                    title: LocaleKeys.noResults.tr(),
                    description: LocaleKeys.vocabularyNoResults.tr(),
                    actionLabel: LocaleKeys.vocabularyResetFilters.tr(),
                    onAction: _reset,
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final columns =
                        constraints.crossAxisExtent >=
                                AppSizes.editorialBreakpoint &&
                            MediaQuery.textScalerOf(context).scale(1) <= 1.5
                        ? 2
                        : 1;
                    return SliverList.builder(
                      itemCount: (entries.length / columns).ceil(),
                      itemBuilder: (context, row) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (
                              var column = 0;
                              column < columns;
                              column++
                            ) ...[
                              if (column > 0)
                                const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: row * columns + column < entries.length
                                    ? _entryCard(
                                        context,
                                        entries[row * columns + column],
                                        introduced,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverPadding(
                padding: AppSpacing.allLG,
                sliver: SliverToBoxAdapter(
                  child: FgDetails(
                    title: LocaleKeys.detailsLearnMore.tr(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.vocabularyBrowseHelp.tr()),
                        const SizedBox(height: AppSpacing.md),
                        Text(LocaleKeys.photoAboutBody.tr()),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSizes.bottomNavHeight + AppSpacing.xxl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _entryCard(
    BuildContext context,
    VocabularyEntry entry,
    Set<String> introduced,
  ) => FgReferenceCard(
    key: ValueKey('vocabulary-${entry.id}'),
    indexLabel: '${const VocabularyRepository().entries.indexOf(entry) + 1}'
        .padLeft(2, '0'),
    title: entry.name,
    label: '${vocabularyKindLabel(entry.kind)} · ${entry.style}',
    definition: entry.definition,
    status: introduced.contains(entry.id)
        ? LocaleKeys.vocabularyIntroduced.tr()
        : LocaleKeys.vocabularyUnexplored.tr(),
    onTap: () => VocabularyDestination(entry.id).push<void>(context),
  );
}
