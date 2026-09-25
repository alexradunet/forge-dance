// THROWAWAY UI comparison on /main/explore?variant=roadmap|stages|next.
// Question: which mobile hierarchy best explains the next step and optional
// branches? Reads real progress; every interaction is preview-only, with no IO.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/design_system.dart';
import '../../../../routing/routes.dart';
import '../../../programmes/repository/programme_catalog.dart';
import '../../model/lesson.dart';
import '../../model/lesson_progress.dart';
import '../view_model/learn_view_model.dart';
import 'roadmap_prototype_data.dart';

const roadmapPrototypeVariants = ['roadmap', 'stages', 'next'];
const _variantLabels = [
  'A · Vertical roadmap',
  'B · Stage by stage',
  'C · Next step first',
];

class LearningRoadmapPrototype extends ConsumerStatefulWidget {
  const LearningRoadmapPrototype({
    required this.variant,
    this.initialSearch,
    super.key,
  });
  final String variant;
  final String? initialSearch;

  @override
  ConsumerState<LearningRoadmapPrototype> createState() =>
      _LearningRoadmapPrototypeState();
}

class _LearningRoadmapPrototypeState
    extends ConsumerState<LearningRoadmapPrototype> {
  String? _focusId;
  String? _stageId;
  String _query = '';
  bool _browse = false;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _query = widget.initialSearch ?? '';
    _search.text = _query;
    _browse = _query.isNotEmpty;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  int get _variant =>
      roadmapPrototypeVariants.indexOf(widget.variant).clamp(0, 2);

  void _cycle(int delta) {
    final variant =
        roadmapPrototypeVariants[(_variant + delta) %
            roadmapPrototypeVariants.length];
    context.replace('${Routes.explore}?variant=$variant');
  }

  @override
  Widget build(BuildContext context) {
    final learn = ref.watch(learnViewModelProvider);
    return FgImmersiveScaffold(
      bodyBuilder: (context) => Focus(
        onKeyEvent: (_, event) {
          final focused = FocusManager.instance.primaryFocus?.context;
          if (focused?.widget is EditableText ||
              focused?.findAncestorWidgetOfExactType<EditableText>() != null ||
              ModalRoute.of(context)?.isCurrent == false ||
              event is! KeyDownEvent) {
            return KeyEventResult.ignored;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _cycle(-1);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _cycle(1);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: learn.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, _) => const FgEmpty(
            icon: Icons.error_outline,
            title: 'Progress unavailable',
          ),
          data: (state) {
            final data = RoadmapPrototypeData(state, _focusId);
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.readingContentMax,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        key: ValueKey(
                          'roadmap-prototype-${widget.variant}-$_browse',
                        ),
                        padding: AppSpacing.allLG,
                        children: [
                          const AppHeader(
                            title: 'Learn',
                            subtitle: 'Roadmap preview · no progress is saved',
                          ),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              FgFilterChip(
                                label: 'My roadmap',
                                isSelected: !_browse,
                                onSelected: (_) =>
                                    setState(() => _browse = false),
                              ),
                              FgFilterChip(
                                label: 'Browse lessons',
                                isSelected: _browse,
                                onSelected: (_) =>
                                    setState(() => _browse = true),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          FgButton(
                            key: const ValueKey('roadmap-focus'),
                            text: data.focus == null
                                ? 'Choose a focus'
                                : 'Focus: ${data.focus!.title}',
                            icon: const Icon(Icons.tune),
                            variant: FgButtonVariant.secondary,
                            onPressed: () => _chooseFocus(context),
                          ),
                          if (data.focus != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Highlighted lessons follow this route. Other branches stay available.',
                            ),
                            FgDetails(
                              title: 'About this focus',
                              child: Text(
                                '${data.focus!.description}\n\n${data.focus!.schedule}',
                              ),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xl),
                          if (_browse)
                            ..._browseContent(context, data)
                          else
                            switch (_variant) {
                              1 => _stages(context, data),
                              2 => _nextFirst(context, data),
                              _ => _roadmap(context, data),
                            },
                          const SizedBox(height: AppSpacing.xl),
                          const Text(
                            'Studied means lesson activity recorded—not mastery or a belt award.',
                          ),
                          FgDetails(
                            title: 'Prototype state',
                            child: Text(
                              'Layout: ${widget.variant}\nFocus: ${_focusId ?? "none"}\nStage: ${_stageId ?? "automatic"}\nBrowse: $_browse\nQuery: $_query\nNext: ${data.next?.lesson.id ?? "none available"}\nSaved progress: read-only\nLesson previews never start a session.',
                            ),
                          ),
                          FgButton(
                            text: 'Back to current catalogue',
                            variant: FgButtonVariant.ghost,
                            onPressed: () => context.go(Routes.explore),
                          ),
                        ],
                      ),
                    ),
                    // Content-sized comparison bar reserves room above real app tabs.
                    Padding(
                      padding: AppSpacing.allSM,
                      child: FgCard(
                        immersive: true,
                        padding: AppSpacing.allSM,
                        child: Row(
                          children: [
                            FgIconButton(
                              icon: Icons.chevron_left,
                              semanticLabel: 'Previous layout',
                              onPressed: () => _cycle(-1),
                            ),
                            Expanded(
                              child: Text(
                                _variantLabels[_variant],
                                textAlign: TextAlign.center,
                              ),
                            ),
                            FgIconButton(
                              icon: Icons.chevron_right,
                              semanticLabel: 'Next layout',
                              onPressed: () => _cycle(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _continue(BuildContext context, RoadmapPrototypeData data) {
    final next = data.next;
    if (next == null) {
      return const FgEmpty(
        icon: Icons.route,
        title: 'No next lesson in this focus',
        description: 'This route is studied or its remaining lessons need prerequisites. Browse the roadmap or choose another focus.',
      );
    }
    return FgRoundPanel(
      label: 'Your next step',
      active: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            next.lesson.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text('${next.module.title} · ${next.lesson.duration}'),
          const SizedBox(height: AppSpacing.md),
          FgButton(
            text: 'Preview next lesson',
            icon: const Icon(Icons.arrow_forward),
            onPressed: () =>
                _previewLesson(context, data, next.module, next.lesson),
          ),
        ],
      ),
    );
  }

  Widget _roadmap(BuildContext context, RoadmapPrototypeData data) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _continue(context, data),
      const SizedBox(height: AppSpacing.xxl),
      const FgSectionHeading(
        title: 'Your foundation',
        subtitle: 'A shared spine. Optional branches along the way.',
      ),
      const SizedBox(height: AppSpacing.lg),
      for (final (index, module) in data.spine.indexed) ...[
        _milestone(
          context,
          data,
          module,
          number: '${index + 1}'.padLeft(2, '0'),
        ),
        ..._branches(context, data, module, {module.id}),
        if (index < data.spine.length - 1)
          const Padding(
            padding: AppSpacing.allSM,
            child: ExcludeSemantics(child: Icon(Icons.south)),
          ),
      ],
      if (data.independent.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.xl),
        const FgSectionHeading(
          title: 'Independent paths',
          subtitle: 'No foundation prerequisite in the current catalogue.',
        ),
        for (final module in data.independent) ...[
          const SizedBox(height: AppSpacing.md),
          _milestone(context, data, module),
          ..._branches(context, data, module, {module.id}),
        ],
      ],
    ],
  );

  List<Widget> _branches(
    BuildContext context,
    RoadmapPrototypeData data,
    Module parent,
    Set<String> visited,
  ) => [
    for (final branch in data.branchesOf(parent))
      if (!visited.contains(branch.id))
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            left: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '↳ Optional branch · from ${parent.title}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              _milestone(context, data, branch),
              ..._branches(context, data, branch, {...visited, branch.id}),
            ],
          ),
        ),
  ];

  Widget _milestone(
    BuildContext context,
    RoadmapPrototypeData data,
    Module module, {
    String? number,
    bool expanded = false,
  }) {
    final learn = data.learn;
    final locked = !learn.isModuleUnlocked(module);
    return FgCard(
      key: ValueKey('roadmap-module-${module.id}'),
      immersive: true,
      isSelected: data.inFocus(module),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${number == null ? "" : "$number · "}${data.status(module)}${data.inFocus(module) ? " · Your focus" : ""}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(module.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${learn.completedCountIn(module)} of ${module.lessons.length} lessons studied',
          ),
          if (locked) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('Requires: ${data.requirements(module)}'),
          ],
          FgDetails(
            key: ValueKey('roadmap-lessons-${module.id}'),
            title: 'Lessons & prerequisites',
            initiallyExpanded: expanded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (module.prerequisiteLessonIds.isNotEmpty)
                  Text(
                    'Prerequisites: ${module.prerequisiteLessonIds.map((id) => learn.lessonById(id)?.title ?? id).join(" · ")}',
                  ),
                for (final lesson in module.lessons)
                  FgButton(
                    text:
                        '${data.lessonInFocus(lesson) ? "Focus · " : ""}${lesson.title}',
                    variant: FgButtonVariant.ghost,
                    icon: Icon(
                      learn.statusOf(lesson) == LessonStatus.completed
                          ? Icons.check_circle_outline
                          : learn.canOpenLesson(lesson.id)
                          ? Icons.play_circle_outline
                          : Icons.lock_outline,
                    ),
                    onPressed: () =>
                        _previewLesson(context, data, module, lesson),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stages(BuildContext context, RoadmapPrototypeData data) {
    final module =
        data.spine.where((m) => m.id == _stageId).firstOrNull ??
        data.spine.where((m) => m.id == data.next?.module.id).firstOrNull ??
        data.spine.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FgSectionHeading(
          title: 'One stage at a time',
          subtitle: 'Choose a stage. See its lessons and branches together.',
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final (index, stage) in data.spine.indexed)
              FgFilterChip(
                label: '${index + 1}. ${stage.title}',
                isSelected: stage.id == module.id,
                onSelected: (_) => setState(() => _stageId = stage.id),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _milestone(context, data, module, expanded: true),
        ..._branches(context, data, module, {module.id}),
        const SizedBox(height: AppSpacing.lg),
        FgButton(
          text: 'Browse every path',
          variant: FgButtonVariant.secondary,
          onPressed: () => setState(() => _browse = true),
        ),
      ],
    );
  }

  Widget _nextFirst(BuildContext context, RoadmapPrototypeData data) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const FgSectionHeading(
        title: 'Just your next step',
        subtitle: 'Keep moving. The full map is here when you need it.',
      ),
      const SizedBox(height: AppSpacing.lg),
      _continue(context, data),
      const SizedBox(height: AppSpacing.xl),
      FgDetails(
        title: 'Available alternatives',
        child: Column(
          children: [
            for (final module in data.learn.modules)
              if (data.learn.isModuleUnlocked(module) &&
                  module.id != data.next?.module.id)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _milestone(context, data, module),
                ),
          ],
        ),
      ),
      FgDetails(
        title: 'See the whole journey',
        child: Column(
          children: [
            for (final module in data.learn.modules)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _milestone(context, data, module),
              ),
          ],
        ),
      ),
    ],
  );

  List<Widget> _browseContent(BuildContext context, RoadmapPrototypeData data) {
    final matches = data.learn.modules.where(
      (module) =>
          module.title.toLowerCase().contains(_query.toLowerCase().trim()) ||
          module.lessons.any(
            (lesson) => lesson.title.toLowerCase().contains(
              _query.toLowerCase().trim(),
            ),
          ),
    );
    return [
      FgInput.search(
        controller: _search,
        placeholder: 'Find a path or lesson',
        showFilter: false,
        onChanged: (value) => setState(() => _query = value),
        onClear: () => setState(() {
          _query = '';
          _search.clear();
        }),
        clearSemanticsLabel: 'Clear search',
      ),
      const SizedBox(height: AppSpacing.lg),
      if (matches.isEmpty)
        const FgEmpty(icon: Icons.search_off, title: 'No matching lessons'),
      for (final module in matches) ...[
        _milestone(context, data, module),
        const SizedBox(height: AppSpacing.md),
      ],
    ];
  }

  Future<void> _chooseFocus(BuildContext context) async {
    final selected = await FgImmersiveScaffold.showModal<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose a focus'),
        content: SizedBox(
          width: AppSizes.readingContentMax,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'A guided route highlights existing lessons. This preview does not enrol you or change their prerequisites.',
                ),
                const SizedBox(height: AppSpacing.md),
                FgButton(
                  text: 'No focus · full roadmap',
                  variant: FgButtonVariant.ghost,
                  onPressed: () => Navigator.pop(context, ''),
                ),
                for (final programme in forgeProgrammes)
                  FgButton(
                    text: programme.title,
                    variant: FgButtonVariant.ghost,
                    onPressed: () => Navigator.pop(context, programme.id),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          FgButton(
            text: 'Cancel',
            variant: FgButtonVariant.ghost,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
    if (mounted && selected != null) {
      setState(() => _focusId = selected.isEmpty ? null : selected);
    }
  }

  void _previewLesson(
    BuildContext context,
    RoadmapPrototypeData data,
    Module module,
    Lesson lesson,
  ) {
    final available = data.learn.canOpenLesson(lesson.id);
    FgImmersiveScaffold.showModal<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lesson.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${module.title} · ${lesson.duration}'),
              const SizedBox(height: AppSpacing.md),
              Text(
                available ? 'Available to study' : 'Locked · complete earlier lessons and required prerequisites.',
              ),
              if (!data.learn.isModuleUnlocked(module))
                Text('Requires: ${data.requirements(module)}'),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Preview only. The finished version would open the lesson here. No lesson has been started or recorded.',
              ),
            ],
          ),
        ),
        actions: [
          FgButton(
            text: 'Back to roadmap',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
