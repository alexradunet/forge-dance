import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../media/ui/evidence_picker.dart';
import '../model/forge_method.dart';
import '../repository/method_catalog.dart';
import 'method_view_model.dart';

class MethodPage extends ConsumerWidget {
  const MethodPage({super.key, this.initialCategory, this.initialAssessmentId});
  final ForgeCategory? initialCategory;
  final String? initialAssessmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (initialAssessmentId case final id?) {
      return _AssessmentPage(assessment: assessmentById(id));
    }
    final progress = ref.watch(methodViewModelProvider);
    return FgImmersiveScaffold(
      title: initialCategory?.label ?? LocaleKeys.methodTitle.tr(),
      bodyBuilder: (context) => FgReadingBody(
        child: progress.when(
          loading: () => const Center(child: FgSpinner()),
          error: (error, _) => Center(
            child: Padding(
              padding: AppSpacing.allLG,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(LocaleKeys.methodLoadError.tr()),
                  const SizedBox(height: AppSpacing.lg),
                  FgButton(
                    text: LocaleKeys.methodRetry.tr(),
                    onPressed: () =>
                        ref.read(methodViewModelProvider.notifier).reload(),
                  ),
                ],
              ),
            ),
          ),
          data: (value) => RefreshIndicator(
            onRefresh: () =>
                ref.read(methodViewModelProvider.notifier).reload(),
            child: ListView(
              padding: AppSpacing.allLG,
              children: [
                if (initialCategory == null) ...[
                  _Summary(progress: value),
                  const SizedBox(height: AppSpacing.xxl),
                  FgSectionHeading(title: LocaleKeys.methodCurrentProfile.tr()),
                  const SizedBox(height: AppSpacing.sm),
                  FgDetails(
                    title: LocaleKeys.detailsAboutMethod.tr(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.methodCurrentHelp.tr()),
                        const SizedBox(height: AppSpacing.md),
                        Text(LocaleKeys.methodCoreCategory.tr()),
                        const SizedBox(height: AppSpacing.sm),
                        Text(LocaleKeys.methodSupportCategory.tr()),
                        const SizedBox(height: AppSpacing.md),
                        Text(LocaleKeys.methodSupportHelp.tr()),
                        const SizedBox(height: AppSpacing.md),
                        Text(LocaleKeys.methodBeltsHelp.tr()),
                        const SizedBox(height: AppSpacing.md),
                        Text(LocaleKeys.forgeCriteriaProvisional.tr()),
                      ],
                    ),
                  ),
                  for (final category in ForgeCategory.values) ...[
                    FgProgramCard(
                      label: category.isCore
                          ? LocaleKeys.compactCore.tr()
                          : LocaleKeys.compactSupport.tr(),
                      title: category.label,
                      details: _categoryLevel(value, category),
                      actionLabel: LocaleKeys.methodChooseAssessment.tr(),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => MethodPage(initialCategory: category),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  FgDetails(
                    key: const ValueKey('method-belt-requirements'),
                    title: LocaleKeys.methodBeltsRequirements.tr(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final belt in forgeBelts) ...[
                          _BeltRequirements(belt: belt, progress: value),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ],
                    ),
                  ),
                ] else ...[
                  FgCard(
                    immersive: true,
                    shape: FgCardShape.editorial,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FgSectionHeading(
                          title: _categoryLevel(value, initialCategory!),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(LocaleKeys.compactSelfAssessed.tr()),
                        FgDetails(
                          title: LocaleKeys.detailsAboutMethod.tr(),
                          child: Text(
                            initialCategory!.isCore
                                ? LocaleKeys.methodCurrentHelp.tr()
                                : LocaleKeys.methodSupportHelp.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FgSectionHeading(
                    title: LocaleKeys.methodChooseAssessment.tr(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final assessment in forgeAssessments.where(
                    (item) => item.category == initialCategory,
                  )) ...[
                    _AssessmentTile(assessment: assessment, progress: value),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
                const SizedBox(height: AppSpacing.xxl),
                FgDetails(
                  title: LocaleKeys.methodDatedEvidence.tr(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (value.attempts
                          .where(
                            (attempt) =>
                                initialCategory == null ||
                                attempt.assessment.category == initialCategory,
                          )
                          .isEmpty)
                        Text(LocaleKeys.methodNoAttempts.tr()),
                      for (final attempt in value.attempts.reversed.where(
                        (attempt) =>
                            initialCategory == null ||
                            attempt.assessment.category == initialCategory,
                      )) ...[
                        _AttemptTile(
                          key: ValueKey(attempt.id),
                          attempt: attempt,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _level(int level) => level == 0
    ? LocaleKeys.methodNotAssessed.tr()
    : LocaleKeys.methodLevel.tr(args: ['$level']);
String _categoryLevel(MethodProgress progress, ForgeCategory category) {
  final level = progress.levelFor(category);
  if (level == 0 &&
      progress.attempts.any(
        (attempt) => attempt.assessment.category == category,
      )) {
    return LocaleKeys.methodWorkingToward.tr();
  }
  return _level(level);
}

String _date(DateTime date) =>
    DateFormat.yMMMd().add_jm().format(date.toLocal());

class _Summary extends StatelessWidget {
  const _Summary({required this.progress});
  final MethodProgress progress;

  @override
  Widget build(BuildContext context) => FgCard(
    immersive: true,
    shape: FgCardShape.editorial,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          progress.earnedBeltIndex == 0
              ? LocaleKeys.forgeEntryBelt.tr()
              : LocaleKeys.methodEarnedBelt.tr(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        FgSectionHeading(title: forgeBelts[progress.earnedBeltIndex].name),
        const SizedBox(height: AppSpacing.sm),
        Text(LocaleKeys.compactSelfAssessed.tr()),
        const SizedBox(height: AppSpacing.lg),
        if (progress.earnedBeltIndex < 7) ...[
          Text(
            LocaleKeys.methodNextBelt.tr(
              args: [forgeBelts[progress.earnedBeltIndex + 1].name],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FgProgressBar(
            value: progress.nextBeltProgress,
            semanticLabel: LocaleKeys.methodRequirementsProgress.tr(),
          ),
        ] else
          Text(LocaleKeys.methodAllBeltsEarned.tr()),
        FgDetails(
          title: LocaleKeys.detailsProgress.tr(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocaleKeys.methodSelfAssessed.tr()),
              for (final award in progress.awards) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  LocaleKeys.methodAwardDate.tr(
                    args: [
                      forgeBelts[award.index].name,
                      _date(award.awardedAt),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _BeltRequirements extends StatelessWidget {
  const _BeltRequirements({required this.belt, required this.progress});
  final MethodBelt belt;
  final MethodProgress progress;

  @override
  Widget build(BuildContext context) {
    final requirements = progress.requirementsForBelt(belt.index);
    final summary = requirements.isEmpty
        ? LocaleKeys.forgeEntryBelt.tr()
        : LocaleKeys.compactBeltProgress.tr(
            args: [
              '${requirements.where((requirement) => requirement.isMet).length}',
              '${requirements.length}',
            ],
          );
    return FgCard(
      immersive: true,
      key: ValueKey('belt-${belt.index}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${belt.name} · $summary',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (!requirements.any((item) => item.description == belt.description))
            Text(belt.description),
          const SizedBox(height: AppSpacing.md),
          for (final requirement in requirements)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    requirement.isMet
                        ? Icons.check_circle_outline
                        : Icons.radio_button_unchecked,
                    color: requirement.isMet
                        ? Theme.of(context).forgeColors.success
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(requirement.description)),
                ],
              ),
            ),
          if (belt.integratedAssessmentId case final id?)
            FgButton(
              text: LocaleKeys.methodOpenIntegrated.tr(),
              variant: FgButtonVariant.secondary,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      _AssessmentPage(assessment: assessmentById(id)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AssessmentTile extends StatelessWidget {
  const _AssessmentTile({required this.assessment, required this.progress});
  final MethodAssessment assessment;
  final MethodProgress progress;

  @override
  Widget build(BuildContext context) {
    final previous = progress.attempts
        .where((attempt) => attempt.assessmentId == assessment.id)
        .lastOrNull;
    return FgCard(
      immersive: true,
      shape: FgCardShape.editorial,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => _AssessmentPage(assessment: assessment),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _level(assessment.level),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          FgSectionHeading(title: assessment.title),
          if (previous != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              LocaleKeys.methodLastResult.tr(
                args: [
                  previous.passed
                      ? LocaleKeys.methodPassed.tr()
                      : LocaleKeys.methodNotYet.tr(),
                  _date(previous.performedAt),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.sm),
            Text(LocaleKeys.methodNotAssessed.tr()),
          ],
        ],
      ),
    );
  }
}

class _AssessmentPage extends ConsumerStatefulWidget {
  const _AssessmentPage({required this.assessment});
  final MethodAssessment assessment;
  @override
  ConsumerState<_AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends ConsumerState<_AssessmentPage> {
  final _met = <String>{};
  final _notes = TextEditingController();
  String? _evidenceId;
  String? _error;
  bool _saving = false;
  bool _confirmed = false;
  AssessmentAttempt? _pendingAttempt;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final now = DateTime.now();
    // Reuse the exact identity after a storage failure so retry cannot duplicate
    // an attempt if the platform wrote successfully before reporting failure.
    final attempt =
        _pendingAttempt ??
        AssessmentAttempt(
          id: 'assessment-${now.microsecondsSinceEpoch}',
          assessmentId: widget.assessment.id,
          performedAt: now,
          metCriteriaIds: widget.assessment.criteria
              .where((criterion) => _met.contains(criterion.id))
              .map((criterion) => criterion.id)
              .toList(),
          notes: _notes.text.trim(),
          evidenceId: _evidenceId,
          rubricVersion: widget.assessment.rubricVersion,
        );
    _pendingAttempt = attempt;
    try {
      await ref
          .read(methodViewModelProvider.notifier)
          .recordAssessment(attempt);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = LocaleKeys.methodSaveError.tr();
        });
      }
    }
  }

  void _changed(VoidCallback change) => setState(() {
    change();
    _pendingAttempt = null;
  });

  @override
  Widget build(BuildContext context) {
    final assessment = widget.assessment;
    final missingNotes = assessment.requiresNotes && _notes.text.trim().isEmpty;
    return PopScope(
      canPop: !_saving,
      child: FgImmersiveScaffold(
        title: assessment.title,
        onBack: () {
          if (!_saving) Navigator.of(context).maybePop();
        },
        bodyBuilder: (context) => FgReadingBody(
          child: ListView(
            padding: AppSpacing.allLG,
            children: [
              FgCard(
                immersive: true,
                shape: FgCardShape.editorial,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.methodRubricVersion.tr(
                        args: [
                          '${assessment.level}',
                          '${assessment.rubricVersion}',
                        ],
                      ),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      assessment.instructions,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(LocaleKeys.compactMethodAssessmentSafety.tr()),
                    FgDetails(
                      title: LocaleKeys.detailsAdaptations.tr(),
                      child: Text(assessment.adaptation),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              FgSectionHeading(title: LocaleKeys.methodMarkCriteria.tr()),
              const SizedBox(height: AppSpacing.sm),
              Text(LocaleKeys.methodMarkHelp.tr()),
              const SizedBox(height: AppSpacing.lg),
              for (final criterion in assessment.criteria) ...[
                FgCard(
                  immersive: true,
                  shape: FgCardShape.editorial,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FgCheckboxItem.simple(
                        isChecked: _met.contains(criterion.id),
                        semanticLabel: criterion.text,
                        isEnabled: !_saving,
                        onTap: () => _changed(() {
                          if (!_met.add(criterion.id)) {
                            _met.remove(criterion.id);
                          }
                        }),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(criterion.text)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.lg),
              FgInput(
                label: LocaleKeys.methodNotes.tr(),
                controller: _notes,
                isEnabled: !_saving,
                onChanged: (_) => _changed(() {}),
              ),
              if (assessment.requiresNotes)
                Text(LocaleKeys.methodNotesRequired.tr()),
              FgDetails(
                title: LocaleKeys.compactMethodNotesGuide.tr(),
                child: Text(LocaleKeys.methodNotesHelp.tr()),
              ),
              const SizedBox(height: AppSpacing.lg),
              AbsorbPointer(
                absorbing: _saving,
                child: EvidencePicker(
                  value: _evidenceId,
                  onChanged: (value) => _changed(() => _evidenceId = value),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  FgCheckboxItem.simple(
                    isChecked: _confirmed,
                    semanticLabel: LocaleKeys.methodConfirm.tr(),
                    isEnabled: !_saving,
                    onTap: () => setState(() => _confirmed = !_confirmed),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(LocaleKeys.methodConfirm.tr())),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _met.length == assessment.criteria.length && !missingNotes
                    ? LocaleKeys.methodPassPreview.tr()
                    : LocaleKeys.methodIncompletePreview.tr(),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              FgButton(
                text: LocaleKeys.methodSaveAssessment.tr(),
                isLoading: _saving,
                isEnabled: _confirmed,
                expand: true,
                onPressed: _save,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttemptTile extends StatelessWidget {
  const _AttemptTile({super.key, required this.attempt});
  final AssessmentAttempt attempt;

  @override
  Widget build(BuildContext context) => FgCard(
    immersive: true,
    shape: FgCardShape.editorial,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FgSectionHeading(title: attempt.assessment.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          LocaleKeys.methodAttemptSummary.tr(
            args: [
              _date(attempt.performedAt),
              attempt.passed
                  ? LocaleKeys.methodPassed.tr()
                  : LocaleKeys.methodNotYet.tr(),
              '${attempt.rubricVersion}',
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final criterion in attempt.assessment.criteria)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Icon(
                  attempt.metCriteriaIds.contains(criterion.id)
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(criterion.text)),
              ],
            ),
          ),
        if (attempt.notes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(attempt.notes),
          ),
        if (attempt.evidenceId case final evidenceId?)
          FgButton(
            text: LocaleKeys.methodViewEvidence.tr(),
            variant: FgButtonVariant.secondary,
            onPressed: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute<void>(
                builder: (_) => EvidenceViewer(evidenceId: evidenceId),
              ),
            ),
          ),
      ],
    ),
  );
}
