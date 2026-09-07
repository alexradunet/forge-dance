import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../repository/media_repository.dart';

/// The only perspective is the one actually recorded. Mirroring never invents
/// an unavailable front/back camera. Phrase boundaries are local video seconds.
class LocalVideoView extends ConsumerStatefulWidget {
  const LocalVideoView({super.key, required this.evidenceId, this.playing});
  final String evidenceId;

  /// Null: standalone preview controls. Non-null: controlled by practice clock.
  final bool? playing;
  @override
  ConsumerState<LocalVideoView> createState() => _LocalVideoViewState();
}

class _LocalVideoViewState extends ConsumerState<LocalVideoView>
    with WidgetsBindingObserver {
  late final Player _player;
  late final VideoController _video;
  final _subscriptions = <StreamSubscription<dynamic>>[];
  String? _title;
  String? _error;
  bool _ready = false;
  bool _mirror = false;
  bool _playing = false;
  bool _requestedPlay = false;
  bool _foreground = true;
  bool _loop = true;
  bool _seeking = false;
  double _speed = 1;
  double _duration = 0;
  double _start = 0;
  double _end = 0;
  double _position = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _player = Player();
    _video = VideoController(_player);
    _subscriptions.add(
      _player.stream.error.listen((_) {
        if (mounted) {
          setState(() {
            _error = LocaleKeys.mediaUnsupported.tr();
            _ready = false;
          });
        }
      }),
    );
    _subscriptions.add(
      _player.stream.duration.listen((duration) {
        if (!mounted || duration.inMilliseconds <= 0) return;
        setState(() {
          _duration = duration.inMilliseconds / 1000;
          if (_end == 0 || _end > _duration) _end = _duration;
        });
      }),
    );
    _subscriptions.add(
      _player.stream.playing.listen((playing) {
        if (mounted) setState(() => _playing = playing);
      }),
    );
    _subscriptions.add(
      _player.stream.position.listen((position) {
        if (!mounted) return;
        final seconds = position.inMilliseconds / 1000;
        setState(() => _position = seconds);
        if (_loop && _end > _start && seconds >= _end && !_seeking) {
          unawaited(_repeat());
        }
      }),
    );
    _subscriptions.add(
      _player.stream.completed.listen((completed) {
        if (completed && _loop && !_seeking) unawaited(_repeat());
      }),
    );
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final repository = ref.read(mediaRepositoryProvider);
      final item = await repository.get(widget.evidenceId);
      if (item == null) throw StateError('missing');
      final bytes = await repository.readBytes(item.id);
      if (!mounted) return;
      final media = await Media.memory(bytes, type: item.mimeType);
      if (!mounted) return;
      await _player.open(media, play: false);
      _requestedPlay = _foreground && (widget.playing ?? false);
      if (mounted && _requestedPlay) await _player.play();
      if (mounted) {
        setState(() {
          _title = item.title;
          _ready = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = LocaleKeys.mediaUnavailable.tr());
    }
  }

  Future<void> _repeat() async {
    _seeking = true;
    try {
      final shouldPlay = _requestedPlay;
      await _player.seek(Duration(milliseconds: (_start * 1000).round()));
      if (mounted && shouldPlay && _requestedPlay) await _player.play();
    } catch (_) {
      if (mounted) setState(() => _error = LocaleKeys.mediaUnsupported.tr());
    } finally {
      _seeking = false;
    }
  }

  Future<void> _command(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      if (mounted) setState(() => _error = LocaleKeys.mediaUnsupported.tr());
    }
  }

  @override
  void didUpdateWidget(covariant LocalVideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playing != widget.playing &&
        widget.playing != null &&
        _ready) {
      _requestedPlay = _foreground && widget.playing!;
      unawaited(_command(_requestedPlay ? _player.play : _player.pause));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (state != AppLifecycleState.resumed) {
      _requestedPlay = false;
      unawaited(_command(_player.pause));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FgCard(
    immersive: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _title ?? LocaleKeys.mediaLoading.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(_mirror ? -1 : 1, 1, 1),
            child: Video(controller: _video, controls: NoVideoControls),
          ),
        ),
        Text(LocaleKeys.mediaRecordedPerspective.tr()),
        if (_error != null)
          Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (_ready) ...[
          if (widget.playing == null)
            FgButton(
              text: (_playing ? LocaleKeys.playerPause : LocaleKeys.playerStart)
                  .tr(),
              onPressed: () {
                _requestedPlay = !_playing;
                unawaited(
                  _command(_requestedPlay ? _player.play : _player.pause),
                );
              },
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(LocaleKeys.mediaMirror.tr()),
            value: _mirror,
            onChanged: (value) => setState(() => _mirror = value),
          ),
          FgSlider(
            value: _speed,
            min: 0.25,
            max: 1.5,
            divisions: 5,
            semanticLabel: LocaleKeys.mediaSpeed.tr(),
            label: LocaleKeys.mediaSpeed.tr(),
            valueLabel: '${_speed.toStringAsFixed(2)}×',
            onChanged: (value) {
              setState(() => _speed = value);
              unawaited(_command(() => _player.setRate(value)));
            },
          ),
          if (_duration > 0) ...[
            FgSlider(
              value: _position.clamp(0, _duration),
              min: 0,
              max: _duration,
              semanticLabel: LocaleKeys.mediaPosition.tr(),
              label: LocaleKeys.mediaPosition.tr(),
              valueLabel:
                  '${_position.toStringAsFixed(1)} / ${_duration.toStringAsFixed(1)} s',
              onChanged: (value) => _command(
                () => _player.seek(
                  Duration(milliseconds: (value * 1000).round()),
                ),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(LocaleKeys.mediaLoop.tr()),
              value: _loop,
              onChanged: (value) => setState(() => _loop = value),
            ),
            if (_loop && _duration > 0.2) ...[
              FgSlider(
                value: _start,
                min: 0,
                max: _duration - 0.1,
                semanticLabel: LocaleKeys.mediaLoopStart.tr(),
                label: LocaleKeys.mediaLoopStart.tr(),
                valueLabel: '${_start.toStringAsFixed(1)} s',
                onChanged: (value) {
                  setState(() => _start = value.clamp(0, _end - 0.1));
                  unawaited(
                    _command(
                      () => _player.seek(
                        Duration(milliseconds: (_start * 1000).round()),
                      ),
                    ),
                  );
                },
              ),
              FgSlider(
                value: _end,
                min: 0.1,
                max: _duration,
                semanticLabel: LocaleKeys.mediaLoopEnd.tr(),
                label: LocaleKeys.mediaLoopEnd.tr(),
                valueLabel: '${_end.toStringAsFixed(1)} s',
                onChanged: (value) =>
                    setState(() => _end = value.clamp(_start + 0.1, _duration)),
              ),
            ],
          ],
        ],
      ],
    ),
  );
}
