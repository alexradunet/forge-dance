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
      bodyBuilder: (context) => progress.when(
        loading: () => const Center(child: CircularProgressIndicator()),
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
          onRefresh: () => ref.read(methodViewModelProvider.notifier).reload(),
          child: ListView(
            padding: AppSpacing.allLG,
            children: [
              if (initialCategory == null) ...[
                _Summary(progress: value),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  LocaleKeys.methodCurrentProfile.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(LocaleKeys.methodCurrentHelp.tr()),
                const SizedBox(height: AppSpacing.lg),
                for (final category in ForgeCategory.values) ...[
                  FgCard(
                    immersive: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => MethodPage(initialCategory: category),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          category.isCore
                              ? Icons.adjust
                              : Icons.health_and_safety_outlined,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.label,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                category.isCore
                                    ? LocaleKeys.methodCoreCategory.tr()
                                    : LocaleKeys.methodSupportCategory.tr(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(child: Text(_categoryLevel(value, category))),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                const SizedBox(height: AppSpacing.lg),
                Text(
                  LocaleKeys.methodBeltsRequirements.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(LocaleKeys.methodBeltsHelp.tr()),
                for (final belt in forgeBelts)
                  _BeltRequirements(belt: belt, progress: value),
              ] else ...[
                FgCard(
                  immersive: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _categoryLevel(value, initialCategory!),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        initialCategory!.isCore
                            ? LocaleKeys.methodCurrentHelp.tr()
                            : LocaleKeys.methodSupportHelp.tr(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  LocaleKeys.methodChooseAssessment.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
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
              Text(
                LocaleKeys.methodDatedEvidence.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
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
                _AttemptTile(attempt: attempt),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.xxl),
            ],
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
        Text(
          forgeBelts[progress.earnedBeltIndex].name,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(LocaleKeys.methodSelfAssessed.tr()),
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
        for (final award in progress.awards) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            LocaleKeys.methodAwardDate.tr(
              args: [forgeBelts[award.index].name, _date(award.awardedAt)],
            ),
          ),
        ],
      ],
    ),
  );
}

class _BeltRequirements extends StatelessWidget {
  const _BeltRequirements({required this.belt, required this.progress});
  final MethodBelt belt;
  final MethodProgress progress;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: Text(belt.name),
    subtitle: Text(belt.description),
    initiallyExpanded: belt.index == progress.earnedBeltIndex + 1,
    childrenPadding: AppSpacing.allLG,
    children: [
      for (final requirement in progress.requirementsForBelt(belt.index))
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
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
              builder: (_) => _AssessmentPage(assessment: assessmentById(id)),
            ),
          ),
        ),
    ],
  );
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
          Text(
            assessment.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(assessment.instructions),
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
    return FgImmersiveScaffold(
      title: assessment.title,
      bodyBuilder: (context) => ListView(
        padding: AppSpacing.allLG,
        children: [
          FgCard(
            immersive: true,
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
                const SizedBox(height: AppSpacing.lg),
                Text(assessment.adaptation),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            LocaleKeys.methodMarkCriteria.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(LocaleKeys.methodMarkHelp.tr()),
          const SizedBox(height: AppSpacing.lg),
          for (final criterion in assessment.criteria) ...[
            FgCard(
              immersive: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FgCheckboxItem.simple(
                    isChecked: _met.contains(criterion.id),
                    semanticLabel: criterion.text,
                    isEnabled: !_saving,
                    onTap: () => _changed(() {
                      if (!_met.add(criterion.id)) _met.remove(criterion.id);
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
            helperText: LocaleKeys.methodNotesHelp.tr(),
            controller: _notes,
            isEnabled: !_saving,
            onChanged: (_) => _changed(() {}),
          ),
          if (assessment.requiresNotes)
            Text(LocaleKeys.methodNotesRequired.tr()),
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
    );
  }
}

class _AttemptTile extends StatelessWidget {
  const _AttemptTile({required this.attempt});
  final AssessmentAttempt attempt;

  @override
  Widget build(BuildContext context) => FgCard(
    immersive: true,
    child: ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(attempt.assessment.title),
      subtitle: Text(
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
      children: [
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
