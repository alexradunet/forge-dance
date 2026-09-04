import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../model/lesson.dart';
import '../repository/lesson_catalog.dart';
import '../ui/view_model/learn_view_model.dart';

/// Plays the user's current lesson step-by-step; the final step offers a
/// completion action that persists progress and unlocks the next lesson.
class LessonPlayerScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  final String lessonId;
  const LessonPlayerScreen({required this.lessonId, super.key, this.onBack});

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  static const _wideMinWidth = 760.0;
  static const _contentMaxWidth = 520.0;
  static const _expandedMediaMaxHeight = 320.0;
  int _currentStep = 0;
  bool _completing = false;
  bool _techniqueExpanded = false;
  bool _mediaCollapsed = false;
  late final PageController _mediaPageController;
  late final ScrollController _contentScrollController;

  @override
  void initState() {
    super.initState();
    _mediaPageController = PageController(initialPage: _currentStep);
    _contentScrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _contentScrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _mediaPageController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_contentScrollController.hasClients || _mediaCollapsed) return;
    if (_contentScrollController.offset > 24) {
      setState(() => _mediaCollapsed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final learnState = ref.watch(learnViewModelProvider);
    final state = learnState.value;

    if (state == null) {
      return Scaffold(
        body: FgBackground(
          child: learnState.hasError
              ? FgEmpty(
                  icon: Icons.error_outline,
                  title: LocaleKeys.unexpectedErrorOccurred.tr(),
                  tone: FgEmptyTone.error,
                )
              : const Center(child: FgSpinner()),
        ),
      );
    }

    if (!state.canOpenLesson(widget.lessonId)) {
      return Scaffold(
        body: FgBackground(
          child: FgEmpty(
            icon: Icons.lock_outline,
            title: LocaleKeys.lockedLabel.tr(),
          ),
        ),
      );
    }

    final lesson = state.activeModule.lessons.firstWhere(
      (lesson) => lesson.id == widget.lessonId,
      orElse: () => state.currentLesson ?? state.activeModule.lessons.last,
    );
    final steps = stepsFor(lesson);
    final lessonNumber = state.activeModule.lessons.indexOf(lesson) + 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: SafeArea(
          top: false,
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= _wideMinWidth;
              return Column(
                children: [
                  AppHeader(
                    title: lesson.title,
                    subtitle: LocaleKeys.lessonNumberType.tr(
                      args: ['$lessonNumber', lesson.type.label],
                    ),
                    onBack: widget.onBack ?? () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: isWide
                        ? _WideLessonLayout(
                            media: _buildMediaPane(
                              steps,
                              expanded: true,
                              minHeight: 160,
                              maxHeight: _expandedMediaMaxHeight,
                            ),
                            content: _buildContentPanel(
                              lesson,
                              steps,
                              isWide: true,
                            ),
                          )
                        : _NarrowLessonLayout(
                            mediaCollapsed: _mediaCollapsed,
                            media: _buildMediaPane(
                              steps,
                              expanded: true,
                              minHeight: 104,
                              maxHeight: (constraints.maxHeight * 0.34).clamp(
                                112.0,
                                _expandedMediaMaxHeight,
                              ),
                            ),
                            mediaDock: _buildMediaDock(steps),
                            content: _buildContentPanel(
                              lesson,
                              steps,
                              isWide: false,
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPane(
    List<LessonStep> steps, {
    required bool expanded,
    required double minHeight,
    required double maxHeight,
  }) {
    final motion = context.forgeMotion;
    return AnimatedContainer(
      key: const ValueKey('lesson-media-shell'),
      duration: motion.standard,
      curve: motion.enterCurve,
      constraints: BoxConstraints(minHeight: minHeight, maxHeight: maxHeight),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            key: const ValueKey('lesson-media-page-view'),
            controller: _mediaPageController,
            onPageChanged: _setCurrentStep,
            itemCount: steps.length,
            itemBuilder: (context, index) => _LessonMedia(step: steps[index]),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Text(
              steps[_currentStep].title,
              maxLines: expanded ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: Theme.of(context).forgeColors.onImmersive),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaDock(List<LessonStep> steps) {
    final step = steps[_currentStep];
    return FgMediaDock(
      key: const ValueKey('lesson-media-dock'),
      thumbnail: _LessonMedia(step: step),
      title: step.title,
      subtitle: LocaleKeys.lessonStepOf.tr(
        args: ['${_currentStep + 1}', '${steps.length}'],
      ),
      onExpand: () => setState(() => _mediaCollapsed = false),
      expandSemanticLabel: LocaleKeys.expandDemonstrationSemantic.tr(),
    );
  }

  Widget _buildContentPanel(
    Lesson lesson,
    List<LessonStep> steps, {
    required bool isWide,
  }) {
    final step = steps[_currentStep];
    final isLastStep = _currentStep == steps.length - 1;
    final content = AnimatedSwitcher(
      duration: context.forgeMotion.standard,
      switchInCurve: context.forgeMotion.enterCurve,
      switchOutCurve: context.forgeMotion.exitCurve,
      transitionBuilder: (child, animation) {
        if (MediaQuery.disableAnimationsOf(context)) return child;
        if (isWide) return FadeTransition(opacity: animation, child: child);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: _LessonStepContent(
        key: ValueKey(step.title),
        step: step,
        techniqueExpanded: _techniqueExpanded,
        onTechniqueChanged: (expanded) {
          if (_techniqueExpanded == expanded) return;
          setState(() => _techniqueExpanded = expanded);
        },
      ),
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            key: const ValueKey('lesson-content-scroll'),
            controller: isWide ? null : _contentScrollController,
            padding: EdgeInsets.all(isWide ? AppSpacing.xxl : AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
              child: content,
            ),
          ),
        ),
        if (isWide)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              0,
              AppSpacing.xxl,
              AppSpacing.xxl,
            ),
            child: _NavigationControls(
              currentStep: _currentStep,
              stepCount: steps.length,
              isLastStep: isLastStep,
              completing: _completing,
              onPrevious: _currentStep == 0 ? null : _previousStep,
              onNext: isLastStep ? () => _completeLesson(lesson) : _nextStep,
            ),
          )
        else
          SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: _NavigationControls(
              currentStep: _currentStep,
              stepCount: steps.length,
              isLastStep: isLastStep,
              completing: _completing,
              onPrevious: _currentStep == 0 ? null : _previousStep,
              onNext: isLastStep ? () => _completeLesson(lesson) : _nextStep,
            ),
          ),
      ],
    );
  }

  Future<void> _goToStep(int index) async {
    if (index == _currentStep || index < 0) return;
    final clamped = index.clamp(0, _currentStepCount - 1);

    if (_mediaCollapsed || !_mediaPageController.hasClients) {
      setState(() {
        _currentStep = clamped;
        _mediaCollapsed = false;
        _techniqueExpanded = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _mediaPageController.hasClients) {
          _mediaPageController.jumpToPage(clamped);
        }
      });
      return;
    }

    _resetStepUi();
    await _mediaPageController.animateToPage(
      clamped,
      duration: context.forgeMotion.standard,
      curve: context.forgeMotion.enterCurve,
    );
    if (mounted && _currentStep != clamped) {
      setState(() => _currentStep = clamped);
    }
  }

  int get _currentStepCount {
    final state = ref.read(learnViewModelProvider).value;
    if (state == null) return 1;
    final lesson = state.activeModule.lessons.firstWhere(
      (lesson) => lesson.id == widget.lessonId,
      orElse: () => state.currentLesson ?? state.activeModule.lessons.last,
    );
    return stepsFor(lesson).length;
  }

  void _previousStep() => _goToStep(_currentStep - 1);

  void _nextStep() => _goToStep(_currentStep + 1);

  void _setCurrentStep(int index) {
    setState(() {
      _currentStep = index;
      _mediaCollapsed = false;
      _techniqueExpanded = false;
    });
  }

  void _resetStepUi() {
    setState(() {
      _mediaCollapsed = false;
      _techniqueExpanded = false;
    });
  }

  Future<void> _completeLesson(Lesson lesson) async {
    if (_completing) return;
    setState(() => _completing = true);

    await ref.read(learnViewModelProvider.notifier).completeLesson(lesson.id);

    if (!mounted) return;
    setState(() => _completing = false);
    widget.onBack?.call();
  }
}

class _WideLessonLayout extends StatelessWidget {
  const _WideLessonLayout({required this.media, required this.content});

  final Widget media;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        0,
        AppSpacing.xxl,
        AppSpacing.xxl,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 3, child: Center(child: media)),
          const SizedBox(width: AppSpacing.xxl),
          Expanded(flex: 2, child: content),
        ],
      ),
    );
  }
}

class _NarrowLessonLayout extends StatelessWidget {
  const _NarrowLessonLayout({
    required this.mediaCollapsed,
    required this.media,
    required this.mediaDock,
    required this.content,
  });

  final bool mediaCollapsed;
  final Widget media;
  final Widget mediaDock;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final motion = context.forgeMotion;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 0),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: motion.standard,
            switchInCurve: motion.enterCurve,
            switchOutCurve: motion.exitCurve,
            child: mediaCollapsed ? mediaDock : media,
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _LessonMedia extends StatelessWidget {
  const _LessonMedia({required this.step});

  final LessonStep step;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FgImage(
          imageUrl: 'https://images.unsplash.com/photo-1535525153412-5a42439a210d?q=80&w=2070&auto=format&fit=crop',
          fit: BoxFit.contain,
          placeholder: const _MediaFallbackIcon(),
          errorWidget: const _MediaFallbackIcon(),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.36),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MediaFallbackIcon extends StatelessWidget {
  const _MediaFallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Icon(
          Icons.directions_run_rounded,
          size: 180,
          color: Theme.of(context).forgeColors.onImmersive
              .withValues(alpha: 0.72),
        ),
      ),
    );
  }
}

class _LessonStepContent extends StatelessWidget {
  const _LessonStepContent({
    super.key,
    required this.step,
    required this.techniqueExpanded,
    required this.onTechniqueChanged,
  });

  final LessonStep step;
  final bool techniqueExpanded;
  final ValueChanged<bool> onTechniqueChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          step.title,
          style: textTheme.headlineSmall?.copyWith(
            color: context.forgeForeground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          step.description.isEmpty
              ? LocaleKeys.lessonSummaryFallback.tr()
              : step.description,
          style: textTheme.bodyLarge?.copyWith(
            color: context.forgeMutedForeground,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Semantics(
          expanded: techniqueExpanded,
          child: ExpansionTile(
            key: PageStorageKey('technique-${step.title}'),
            initiallyExpanded: techniqueExpanded,
            onExpansionChanged: onTechniqueChanged,
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: AppSpacing.lg),
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            shape: const Border(),
            collapsedShape: const Border(),
            iconColor: context.forgeMutedForeground,
            collapsedIconColor: context.forgeMutedForeground,
            title: Text(
              LocaleKeys.techniqueDetails.tr(),
              style: TextStyle(color: context.forgeForeground),
            ),
            subtitle: Text(
              LocaleKeys.techniqueDetailsHint.tr(),
              style: TextStyle(color: context.forgeMutedForeground),
            ),
            children: [
              if (step.description.isNotEmpty)
                _TechniquePoint(
                  label: LocaleKeys.descriptionLabel.tr(),
                  value: step.description,
                ),
              if (step.focus.isNotEmpty)
                _TechniquePoint(
                  label: LocaleKeys.focusLabel.tr(),
                  value: step.focus,
                ),
              if (step.breath.isNotEmpty)
                _TechniquePoint(
                  label: LocaleKeys.breathLabel.tr(),
                  value: step.breath,
                ),
              if (step.energy.isNotEmpty)
                _TechniquePoint(
                  label: LocaleKeys.energyLabel.tr(),
                  value: step.energy,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TechniquePoint extends StatelessWidget {
  const _TechniquePoint({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FgLabel(text: label, tone: FgLabelTone.accent),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: context.forgeForeground),
          ),
        ],
      ),
    );
  }
}

class _NavigationControls extends StatelessWidget {
  const _NavigationControls({
    required this.currentStep,
    required this.stepCount,
    required this.isLastStep,
    required this.completing,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentStep;
  final int stepCount;
  final bool isLastStep;
  final bool completing;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final stepLabel = LocaleKeys.lessonStepOf.tr(
      args: ['${currentStep + 1}', '$stepCount'],
    );

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowLeft): _PreviousStepIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): _NextStepIntent(),
      },
      child: Actions(
        actions: {
          _PreviousStepIntent: CallbackAction<_PreviousStepIntent>(
            onInvoke: (_) {
              onPrevious?.call();
              return null;
            },
          ),
          _NextStepIntent: CallbackAction<_NextStepIntent>(
            onInvoke: (_) {
              onNext?.call();
              return null;
            },
          ),
        },
        child: FgStepNavigation(
          currentStep: currentStep,
          stepCount: stepCount,
          stepLabel: stepLabel,
          previousSemanticLabel: LocaleKeys.previousStepSemantic.tr(
            args: ['${currentStep + 1}', '$stepCount'],
          ),
          nextSemanticLabel: isLastStep
              ? LocaleKeys.completeLesson.tr()
              : LocaleKeys.nextStepSemantic.tr(
                  args: ['${currentStep + 1}', '$stepCount'],
                ),
          onPrevious: onPrevious,
          onNext: onNext,
          nextLoading: completing,
        ),
      ),
    );
  }
}

class _PreviousStepIntent extends Intent {
  const _PreviousStepIntent();
}

class _NextStepIntent extends Intent {
  const _NextStepIntent();
}
