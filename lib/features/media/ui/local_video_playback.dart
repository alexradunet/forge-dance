import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_video_playback.g.dart';

/// Native playback boundary. Created only after local metadata/bytes are read;
/// screen contracts can exercise transport without loading a native decoder.
abstract interface class LocalVideoPlayback {
  Stream<String> get errors;
  Stream<Duration> get duration;
  Stream<Duration> get position;
  Stream<bool> get playing;
  Stream<bool> get completed;
  Widget buildVideo();
  Future<void> open(Uint8List bytes, String mimeType);
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> setRate(double rate);
  Future<void> dispose();
}

@riverpod
LocalVideoPlayback Function() localVideoPlaybackFactory(Ref ref) =>
    MediaKitLocalVideoPlayback.new;

class MediaKitLocalVideoPlayback implements LocalVideoPlayback {
  MediaKitLocalVideoPlayback() : _player = Player() {
    _video = VideoController(_player);
  }
  final Player _player;
  late final VideoController _video;
  @override
  Stream<String> get errors => _player.stream.error;
  @override
  Stream<Duration> get duration => _player.stream.duration;
  @override
  Stream<Duration> get position => _player.stream.position;
  @override
  Stream<bool> get playing => _player.stream.playing;
  @override
  Stream<bool> get completed => _player.stream.completed;
  @override
  Widget buildVideo() => Video(controller: _video, controls: NoVideoControls);
  @override
  Future<void> open(Uint8List bytes, String mimeType) async =>
      _player.open(await Media.memory(bytes, type: mimeType), play: false);
  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> setRate(double rate) => _player.setRate(rate);
  @override
  Future<void> dispose() => _player.dispose();
}
