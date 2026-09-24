import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../media/ui/evidence_picker.dart';
import '../../media/ui/local_video_view.dart';
import '../../method/repository/method_catalog.dart';
import '../../practice/model/practice.dart';
import '../../practice/model/workout_session.dart';
import '../model/practice_clock.dart';

/// Returns a completed record only. The launching flow owns persistence once.
class PracticePlayerPage extends StatefulWidget {
  const PracticePlayerPage({
    super.key,
    required this.block,
    this.session,
    this.navigation,
    this.onExit,
    this.onNext,
  });
  final WorkoutSession? session;
  final Widget? navigation;
  final VoidCallback? onExit;
  final VoidCallback? onNext;
  final PracticeBlock block;
  @override
  State<PracticePlayerPage> createState() => _PracticePlayerPageState();
}

class _PracticePlayerPageState extends State<PracticePlayerPage>
    with WidgetsBindingObserver {
  late final PracticeClock _clock;
  Player? _audio;
  StreamSubscription<String>? _audioErrors;
  final _notes = TextEditingController();
  late final WorkoutRound _round;
  DateTime get _performedAt => _round.performedAt;
  bool get _muted => _round.muted;
  set _muted(bool value) => _round.muted = value;
  bool get _independent => _round.independent;
  set _independent(bool value) => _round.independent = value;
  bool _loading = false;
  bool _goalReached = false;
  bool _editingMedia = false;
  bool get _showSchematic => _round.showSchematic;
  set _showSchematic(bool value) => _round.showSchematic = value;
  int _epoch = 0;
  int? _sessionRevision;
  int get _difficulty => _round.difficulty;
  set _difficulty(int value) => _round.difficulty = value;
  String? get _evidence => _round.evidence;
  set _evidence(String? value) => _round.evidence = value;
  String? get _demonstration => _round.demonstration;
  set _demonstration(String? value) => _round.demonstration = value;
  String? _audioError;
  bool get _editable => widget.session == null || widget.session!.editable;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _round =
        widget.session?.current ??
        WorkoutRound(
          widget.block,
          PracticeClock(bpm: widget.block.bpm),
          DateTime.now(),
        );
    _clock = _round.clock..addListener(_tick);
    _notes.text = _round.notes;
    _notes.addListener(() => _round.notes = _notes.text);
    _goalReached = _round.reachedTarget;
    _sessionRevision = widget.session?.playbackRevision;
    widget.session?.addListener(_sessionChanged);
  }

  void _sessionChanged() {
    final revision = widget.session?.playbackRevision;
    if (revision != _sessionRevision) {
      _sessionRevision = revision;
      _pause();
    }
  }

  void _ensureAudio() {
    if (_audio != null) return;
    _audio = Player();
    _audioErrors = _audio!.stream.error.listen((_) {
      if (mounted) {
        _pause();
        setState(() => _audioError = LocaleKeys.playerAudioError.tr());
      }
    });
  }

  void _tick() {
    if (!mounted) return;
    if (!_clock.running) {
      ++_epoch;
      _pauseAudio();
    }
    if (!_goalReached &&
        _clock.activeDuration.inSeconds >= widget.block.minutes * 60) {
      _goalReached = true;
      _pause();
    }
    if (_clock.activeDuration.inSeconds >= 86400) _pause();
    setState(() {});
  }

  Future<void> _start() async {
    if ((widget.session != null &&
            (!widget.session!.editable || _round.reachedTarget)) ||
        _loading ||
        _clock.running ||
        _clock.activeDuration.inSeconds >= 86400) {
      return;
    }
    final epoch = ++_epoch;
    final revision = widget.session?.playbackRevision;
    bool valid() =>
        mounted &&
        epoch == _epoch &&
        (widget.session == null || widget.session!.canStart(_round, revision!));
    setState(() {
      _loading = true;
      _editingMedia = false;
    });
    try {
      if (!_muted) {
        _ensureAudio();
        if (_audio == null) throw StateError('Audio unavailable');
        await _audio!.open(
          await Media.memory(makeMetronomeWav(_clock.bpm), type: 'audio/wav'),
          play: false,
        );
        await _audio!.setPlaylistMode(PlaylistMode.single);
        if (!valid()) return;
        await _audio!.play();
      }
      if (!valid()) {
        await _audio?.pause();
        return;
      }
      _clock.start();
    } catch (_) {
      if (mounted) {
        setState(() => _audioError = LocaleKeys.playerAudioError.tr());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _pause() {
    ++_epoch;
    _clock.pause();
    _pauseAudio();
  }

  void _pauseAudio() {
    final audio = _audio;
    if (audio != null) {
      unawaited(
        audio.pause().catchError((Object _) {
          if (mounted) {
            setState(() => _audioError = LocaleKeys.playerAudioError.tr());
          }
        }),
      );
    }
  }

  void _save() {
    _pause();
    if (_clock.activeDuration.inSeconds < 1) return;
    final variant =
        '${_independent ? LocaleKeys.playerIndependent.tr() : LocaleKeys.playerGuided.tr()}; '
        '${LocaleKeys.playerPhrase.tr()}: ${_clock.phraseStart}–${_clock.phraseEnd}; ${widget.block.adaptation}';
    final record = PracticeRecord(
      id: PracticeRecord.createId(),
      blockId: widget.block.id,
      title: widget.block.title,
      lessonId: widget.block.lessonId,
      vocabularyId: widget.block.vocabularyId,
      workoutId: widget.block.workoutId,
      workoutDate: widget.block.workoutDate,
      category: widget.block.category,
      level: widget.block.level,
      performedAt: _performedAt,
      durationSeconds: _clock.activeDuration.inSeconds,
      bpm: _clock.bpm,
      attempts: _clock.attempts.clamp(1, 10000),
      difficulty: _difficulty,
      notes: '$variant\n${_notes.text.trim()}',
      evidenceId: _evidence,
    );
    Navigator.of(context).pop(record);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _pause();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ++_epoch;
    widget.session?.removeListener(_sessionChanged);
    _clock.removeListener(_tick);
    _pauseAudio();
    if (widget.session == null) _clock.dispose();
    unawaited(_audioErrors?.cancel());
    unawaited(_audio?.dispose());
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = _clock.activeDuration.inSeconds;
    final cueIndex = widget.block.cues.isEmpty
        ? 0
        : ((_clock.beat - 1) * widget.block.cues.length ~/ 8).clamp(
            0,
            widget.block.cues.length - 1,
          );
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _pause();
      },
      child: FgImmersiveScaffold(
        bodyBuilder: (context) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.readingContentMax,
            ),
            child: ListView(
              padding: AppSpacing.allLG,
              children: [
                AppHeader(
                  title: widget.block.title,
                  onBack:
                      widget.onExit ?? () => Navigator.of(context).maybePop(),
                ),
                if (widget.navigation != null) widget.navigation!,
                FgRoundPanel(
                  label: widget.block.workoutId != null
                      ? '${LocaleKeys.cypherPracticeFloor.tr()} · ${LocaleKeys.dailyPracticeVariation.tr(args: [forgeBelts[widget.block.level].name])}'
                      : LocaleKeys.cypherPracticeFloor.tr(),
                  active: _clock.running,
                  child: FgPracticeMeter(
                    elapsed:
                        '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}',
                    elapsedSemanticLabel: LocaleKeys.playerActiveSeconds.tr(
                      args: ['$seconds'],
                    ),
                    target: LocaleKeys.compactTarget.tr(
                      args: ['${widget.block.minutes}'],
                    ),
                    progress: seconds / (widget.block.minutes * 60),
                    status: _clock.countIn > 0
                        ? LocaleKeys.playerCountIn.tr(
                            args: ['${_clock.countIn}'],
                          )
                        : _clock.running
                        ? LocaleKeys.playerCount.tr(args: ['${_clock.beat}'])
                        : (seconds > 0
                                  ? LocaleKeys.playerPaused
                                  : LocaleKeys.compactReady)
                              .tr(),
                    announceStatus: _clock.countIn > 0,
                    activeCount: _clock.running && _clock.countIn == 0
                        ? _clock.beat
                        : null,
                    firstCount: _clock.phraseStart,
                    lastCount: _clock.phraseEnd,
                    metadata: LocaleKeys.playerRhythmSummary.tr(
                      args: [
                        '${_clock.bpm}',
                        '${_clock.phraseStart}',
                        '${_clock.phraseEnd}',
                      ],
                    ),
                  ),
                ),
                if (_goalReached &&
                    (widget.session == null ||
                        _round.status == WorkoutRoundStatus.current)) ...[
                  const SizedBox(height: AppSpacing.md),
                  Semantics(
                    liveRegion: true,
                    container: true,
                    child: Text(
                      widget.session == null
                          ? LocaleKeys.playerGoalReached.tr()
                          : LocaleKeys.workoutTargetReached.tr(),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                // Controls precede changing cues so a different cue length
                // cannot move the pause target while someone is practising.
                FgButton(
                  text:
                      (_clock.running
                              ? LocaleKeys.playerPause
                              : LocaleKeys.playerStart)
                          .tr(),
                  isLoading: _loading,
                  icon: Icon(_clock.running ? Icons.pause : Icons.play_arrow),
                  onPressed:
                      widget.session != null &&
                          (!widget.session!.editable || _round.reachedTarget)
                      ? null
                      : _clock.running
                      ? _pause
                      : _start,
                ),
                const SizedBox(height: AppSpacing.sm),
                FgButton(
                  text: widget.session == null
                      ? LocaleKeys.playerSave.tr()
                      : LocaleKeys.workoutSaveNext.tr(),
                  icon: const Icon(Icons.check),
                  variant: FgButtonVariant.secondary,
                  isEnabled: widget.session == null
                      ? seconds > 0 && !_loading
                      : _round.reachedTarget && widget.session!.editable,
                  onPressed: widget.onNext ?? _save,
                ),
                const SizedBox(height: AppSpacing.lg),
                FgRoundPanel(
                  label:
                      (_independent
                              ? LocaleKeys.playerIndependent
                              : LocaleKeys.playerFocus)
                          .tr(),
                  child: Text(
                    _independent
                        ? LocaleKeys.playerIndependentHelp.tr()
                        : widget.block.cues.isNotEmpty
                        ? widget.block.cues[cueIndex]
                        : widget.block.adaptation,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  LocaleKeys.compactPracticeSafety.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_audioError != null)
                  Semantics(liveRegion: true, child: Text(_audioError!)),
                FgDetails(
                  key: const ValueKey('player-setup'),
                  title: LocaleKeys.playerSetup.tr(),
                  maintainState: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(LocaleKeys.playerMute.tr()),
                        value: _muted,
                        onChanged: !_editable
                            ? null
                            : (value) {
                                if (widget.session != null &&
                                    !widget.session!.editable) {
                                  return;
                                }
                                _pause();
                                setState(() => _muted = value);
                              },
                      ),
                      FgSlider(
                        value: _clock.bpm.toDouble(),
                        min: 20,
                        max: 300,
                        divisions: 280,
                        semanticLabel: LocaleKeys.playerTempo.tr(),
                        label: LocaleKeys.playerTempo.tr(),
                        valueLabel: '${_clock.bpm} BPM',
                        onChanged: !_editable
                            ? null
                            : (value) {
                                if (widget.session != null &&
                                    !widget.session!.editable) {
                                  return;
                                }
                                _pause();
                                _clock.setTempo(value.round());
                              },
                      ),
                      Text(
                        LocaleKeys.playerPhrase.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Wrap(
                        spacing: AppSpacing.lg,
                        runSpacing: AppSpacing.sm,
                        children: [
                          DropdownButton<int>(
                            value: _clock.phraseStart,
                            items: List.generate(
                              _clock.phraseEnd,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text(
                                  LocaleKeys.playerFromCount.tr(
                                    args: ['${i + 1}'],
                                  ),
                                ),
                              ),
                            ),
                            onChanged: !_editable
                                ? null
                                : (value) {
                                    if (widget.session != null &&
                                        !widget.session!.editable) {
                                      return;
                                    }
                                    if (value != null) {
                                      _pause();
                                      _clock.setPhrase(value, _clock.phraseEnd);
                                    }
                                  },
                          ),
                          DropdownButton<int>(
                            value: _clock.phraseEnd,
                            items: List.generate(
                              9 - _clock.phraseStart,
                              (i) => DropdownMenuItem(
                                value: i + _clock.phraseStart,
                                child: Text(
                                  LocaleKeys.playerToCount.tr(
                                    args: ['${i + _clock.phraseStart}'],
                                  ),
                                ),
                              ),
                            ),
                            onChanged: !_editable
                                ? null
                                : (value) {
                                    if (widget.session != null &&
                                        !widget.session!.editable) {
                                      return;
                                    }
                                    if (value != null) {
                                      _pause();
                                      _clock.setPhrase(
                                        _clock.phraseStart,
                                        value,
                                      );
                                    }
                                  },
                          ),
                        ],
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(LocaleKeys.playerIndependent.tr()),
                        value: _independent,
                        onChanged: !_editable
                            ? null
                            : (value) {
                                if (widget.session != null &&
                                    !widget.session!.editable) {
                                  return;
                                }
                                _pause();
                                setState(() => _independent = value);
                              },
                      ),
                      Text(LocaleKeys.playerTempoPause.tr()),
                    ],
                  ),
                ),
                if (!_independent) ...[
                  const SizedBox(height: AppSpacing.lg),
                  if (_demonstration != null)
                    LocalVideoView(
                      key: ValueKey(_demonstration),
                      evidenceId: _demonstration!,
                      playing: _clock.running && _clock.countIn == 0,
                    ),
                  if (_showSchematic) _StepTouchDiagram(beat: _clock.beat),
                ],
                const SizedBox(height: AppSpacing.lg),
                FgButton(
                  text: LocaleKeys.playerMedia.tr(),
                  icon: Icon(
                    _editingMedia ? Icons.expand_less : Icons.attach_file,
                  ),
                  variant: FgButtonVariant.secondary,
                  onPressed: () {
                    _pause();
                    setState(() => _editingMedia = !_editingMedia);
                  },
                ),
                if (_editingMedia) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(LocaleKeys.playerNoTeacherVideo.tr()),
                  Text(LocaleKeys.playerManageMedia.tr()),
                  if (!_independent)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(LocaleKeys.playerSchematic.tr()),
                      value: _showSchematic,
                      onChanged: !_editable
                          ? null
                          : (value) => setState(() {
                              if (widget.session == null ||
                                  widget.session!.editable) {
                                _showSchematic = value;
                              }
                            }),
                    ),
                  Text(
                    LocaleKeys.playerDemoMedia.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  EvidencePicker(
                    isReadOnly: !_editable,
                    value: _demonstration,
                    onChanged: (value) => setState(() {
                      if (widget.session == null || widget.session!.editable) {
                        _demonstration = value;
                      }
                    }),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    LocaleKeys.playerEvidence.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  EvidencePicker(
                    isReadOnly: !_editable,
                    value: _evidence,
                    onChanged: (value) => setState(() {
                      if (widget.session == null || widget.session!.editable) {
                        _evidence = value;
                      }
                    }),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                FgDetails(
                  key: const ValueKey('player-reflection'),
                  title: LocaleKeys.playerReflection.tr(),
                  maintainState: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(LocaleKeys.playerReflectionHelp.tr()),
                      const SizedBox(height: AppSpacing.md),
                      FgSlider(
                        value: _difficulty.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        semanticLabel: LocaleKeys.playerEffort.tr(),
                        label: LocaleKeys.playerEffort.tr(),
                        valueLabel: '$_difficulty / 10',
                        onChanged: !_editable
                            ? null
                            : (value) => setState(() {
                                if (widget.session == null ||
                                    widget.session!.editable) {
                                  _difficulty = value.round();
                                }
                              }),
                      ),
                      if (!_editable) ...[
                        Text(
                          LocaleKeys.playerNotes.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(_notes.text),
                      ] else
                        FgInput(
                          label: LocaleKeys.playerNotes.tr(),
                          controller: _notes,
                          isEnabled:
                              widget.session == null ||
                              widget.session!.editable,
                          onChanged: !_editable
                              ? null
                              : (value) {
                                  if (widget.session != null &&
                                      !widget.session!.editable) {
                                    return;
                                  }
                                  if (value.length > 9000) {
                                    _notes.text = value.substring(0, 9000);
                                  }
                                },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FgDetails(
                  title: LocaleKeys.detailsAdaptations.tr(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.block.adaptation),
                      const SizedBox(height: AppSpacing.sm),
                      Text(LocaleKeys.playerSafety.tr()),
                    ],
                  ),
                ),
                FgDetails(
                  title: LocaleKeys.detailsPlayback.tr(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(LocaleKeys.playerOffline.tr()),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        LocaleKeys.playerTarget.tr(
                          args: ['${widget.block.minutes}'],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(LocaleKeys.playerReady.tr()),
                      const SizedBox(height: AppSpacing.sm),
                      Text(LocaleKeys.playerCueTiming.tr()),
                      const SizedBox(height: AppSpacing.sm),
                      Text(LocaleKeys.playerTempoPause.tr()),
                      const SizedBox(height: AppSpacing.sm),
                      Text(LocaleKeys.playerIndependentHelp.tr()),
                      const SizedBox(height: AppSpacing.sm),
                      Text(LocaleKeys.playerNoTeacherVideo.tr()),
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

/// An original schematic, not educator footage or a claim about the current drill.
class _StepTouchDiagram extends StatelessWidget {
  const _StepTouchDiagram({required this.beat});
  final int beat;
  @override
  Widget build(BuildContext context) {
    final phase = (beat - 1) % 4;
    final words = [
      LocaleKeys.playerStepLeft,
      LocaleKeys.playerTouchRight,
      LocaleKeys.playerStepRight,
      LocaleKeys.playerTouchLeft,
    ];
    return Column(
      children: [
        Text(LocaleKeys.playerSchematicHelp.tr()),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              phase < 2 ? Icons.arrow_back : Icons.remove,
              size: AppSpacing.huge2,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Icon(Icons.accessibility_new, size: AppSpacing.huge3),
            Icon(
              phase >= 2 ? Icons.arrow_forward : Icons.remove,
              size: AppSpacing.huge2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        Text(words[phase].tr(), style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
