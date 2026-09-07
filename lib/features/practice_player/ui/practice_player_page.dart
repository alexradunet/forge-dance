import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../media/ui/evidence_picker.dart';
import '../../media/ui/local_video_view.dart';
import '../../practice/model/practice.dart';
import '../model/practice_clock.dart';

/// Returns a completed record only. The launching flow owns persistence once.
class PracticePlayerPage extends StatefulWidget {
  const PracticePlayerPage({super.key, required this.block});
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
  final _performedAt = DateTime.now();
  bool _muted = false;
  bool _independent = false;
  bool _loading = false;
  bool _goalReached = false;
  bool _editingMedia = false;
  bool _showSchematic = false;
  int _epoch = 0;
  int _difficulty = 5;
  String? _evidence;
  String? _demonstration;
  String? _audioError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _clock = PracticeClock(bpm: widget.block.bpm)..addListener(_tick);
    try {
      _audio = Player();
      _audioErrors = _audio!.stream.error.listen((_) {
        if (mounted) {
          _pause();
          setState(() => _audioError = LocaleKeys.playerAudioError.tr());
        }
      });
    } catch (_) {
      _audioError = LocaleKeys.playerAudioError.tr();
    }
  }

  void _tick() {
    if (!mounted) return;
    if (!_goalReached &&
        _clock.activeDuration.inSeconds >= widget.block.minutes * 60) {
      _goalReached = true;
      _pause();
    }
    if (_clock.activeDuration.inSeconds >= 86400) _pause();
    setState(() {});
  }

  Future<void> _start() async {
    if (_loading ||
        _clock.running ||
        _clock.activeDuration.inSeconds >= 86400) {
      return;
    }
    final epoch = ++_epoch;
    setState(() {
      _loading = true;
      _editingMedia = false;
    });
    try {
      if (!_muted) {
        if (_audio == null) throw StateError('Audio unavailable');
        await _audio!.open(
          await Media.memory(makeMetronomeWav(_clock.bpm), type: 'audio/wav'),
          play: false,
        );
        await _audio!.setPlaylistMode(PlaylistMode.single);
        if (!mounted || epoch != _epoch) return;
        await _audio!.play();
      }
      if (!mounted || epoch != _epoch) {
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
    _clock.removeListener(_tick);
    _clock.dispose();
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
        title: widget.block.title,
        bodyBuilder: (context) => ListView(
          padding: AppSpacing.allLG,
          children: [
            Text(LocaleKeys.playerOffline.tr()),
            Text(widget.block.adaptation),
            const SizedBox(height: AppSpacing.lg),
            FgCard(
              immersive: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.displayLarge,
                    semanticsLabel: LocaleKeys.playerActiveSeconds.tr(
                      args: ['$seconds'],
                    ),
                  ),
                  Text(
                    LocaleKeys.playerTarget.tr(
                      args: ['${widget.block.minutes}'],
                    ),
                  ),
                  if (_goalReached) Text(LocaleKeys.playerGoalReached.tr()),
                  const SizedBox(height: AppSpacing.lg),
                  Semantics(
                    liveRegion: _clock.countIn > 0,
                    child: Text(
                      _clock.countIn > 0
                          ? LocaleKeys.playerCountIn.tr(
                              args: ['${_clock.countIn}'],
                            )
                          : _clock.running
                          ? LocaleKeys.playerCount.tr(args: ['${_clock.beat}'])
                          : LocaleKeys.playerReady.tr(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  if (!_independent && widget.block.cues.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      widget.block.cues[cueIndex],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(LocaleKeys.playerCueTiming.tr()),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      FgButton(
                        text:
                            (_clock.running
                                    ? LocaleKeys.playerPause
                                    : LocaleKeys.playerStart)
                                .tr(),
                        isLoading: _loading,
                        icon: Icon(
                          _clock.running ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: _clock.running ? _pause : _start,
                      ),
                      FgButton(
                        text: LocaleKeys.playerSave.tr(),
                        variant: FgButtonVariant.secondary,
                        isEnabled: seconds > 0 && !_loading,
                        onPressed: _save,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_audioError != null)
              Semantics(liveRegion: true, child: Text(_audioError!)),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(LocaleKeys.playerMute.tr()),
              value: _muted,
              onChanged: (value) {
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
              onChanged: (value) {
                _pause();
                _clock.setTempo(value.round());
              },
            ),
            Text(LocaleKeys.playerTempoPause.tr()),
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
                        LocaleKeys.playerFromCount.tr(args: ['${i + 1}']),
                      ),
                    ),
                  ),
                  onChanged: (value) {
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
                  onChanged: (value) {
                    if (value != null) {
                      _pause();
                      _clock.setPhrase(_clock.phraseStart, value);
                    }
                  },
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(LocaleKeys.playerIndependent.tr()),
              subtitle: Text(LocaleKeys.playerIndependentHelp.tr()),
              value: _independent,
              onChanged: (value) {
                _pause();
                setState(() => _independent = value);
              },
            ),
            if (!_independent) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(LocaleKeys.playerNoTeacherVideo.tr()),
              if (_demonstration != null)
                LocalVideoView(
                  key: ValueKey(_demonstration),
                  evidenceId: _demonstration!,
                  playing: _clock.running && _clock.countIn == 0,
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(LocaleKeys.playerSchematic.tr()),
                value: _showSchematic,
                onChanged: (value) => setState(() => _showSchematic = value),
              ),
              if (_showSchematic) _StepTouchDiagram(beat: _clock.beat),
            ],
            const SizedBox(height: AppSpacing.lg),
            FgButton(
              text: LocaleKeys.playerManageMedia.tr(),
              variant: FgButtonVariant.secondary,
              onPressed: () {
                _pause();
                setState(() => _editingMedia = !_editingMedia);
              },
            ),
            if (_editingMedia) ...[
              Text(
                LocaleKeys.playerDemoMedia.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              EvidencePicker(
                value: _demonstration,
                onChanged: (value) => setState(() => _demonstration = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                LocaleKeys.playerEvidence.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              EvidencePicker(
                value: _evidence,
                onChanged: (value) => setState(() => _evidence = value),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            FgSlider(
              value: _difficulty.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              semanticLabel: LocaleKeys.playerEffort.tr(),
              label: LocaleKeys.playerEffort.tr(),
              valueLabel: '$_difficulty / 10',
              onChanged: (value) => setState(() => _difficulty = value.round()),
            ),
            FgInput(
              label: LocaleKeys.playerNotes.tr(),
              controller: _notes,
              onChanged: (value) {
                if (value.length > 9000) {
                  _notes.text = value.substring(0, 9000);
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(LocaleKeys.playerSafety.tr()),
          ],
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
