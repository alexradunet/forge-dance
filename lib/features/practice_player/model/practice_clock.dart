import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// Monotonic active duration, excluding count-in and pauses. The UI ticker only
/// samples time; it never increments duration, so delayed frames cannot add time.
class PracticeClock extends ChangeNotifier {
  PracticeClock({required int bpm, Stopwatch? stopwatch})
    : bpm = bpm.clamp(20, 300),
      _watch = stopwatch ?? Stopwatch();
  final Stopwatch _watch;
  Timer? _ticker;
  int bpm;
  int phraseStart = 1;
  int phraseEnd = 8;
  int _accumulatedMicros = 0;
  int _completedAttempts = 0;
  bool running = false;
  bool _disposed = false;

  int get _beatMicros => (60000000 / bpm).round();
  int get countIn => !running || _watch.elapsedMicroseconds >= 4 * _beatMicros
      ? 0
      : 4 - _watch.elapsedMicroseconds ~/ _beatMicros;
  int get _activeMicros =>
      math.max(0, _watch.elapsedMicroseconds - 4 * _beatMicros);
  Duration get activeDuration =>
      Duration(microseconds: _accumulatedMicros + _activeMicros);
  int get beat =>
      phraseStart +
      ((_activeMicros ~/ _beatMicros) % (phraseEnd - phraseStart + 1));
  int get attempts => math.max(
    1,
    _completedAttempts +
        _activeMicros ~/ (_beatMicros * (phraseEnd - phraseStart + 1)),
  );

  void start() {
    if (running || _disposed) return;
    running = true;
    _watch.start();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) => notifyListeners(),
    );
    notifyListeners();
  }

  void pause() {
    if (!running) return;
    _watch.stop();
    _accumulatedMicros += _activeMicros;
    _completedAttempts +=
        _activeMicros ~/ (_beatMicros * (phraseEnd - phraseStart + 1));
    _watch.reset();
    running = false;
    _ticker?.cancel();
    _ticker = null;
    notifyListeners();
  }

  void setTempo(int value) {
    pause();
    bpm = value.clamp(20, 300);
    notifyListeners();
  }

  void setPhrase(int start, int end) {
    if (start < 1 || end > 8 || start > end) {
      throw ArgumentError('Invalid phrase');
    }
    pause();
    phraseStart = start;
    phraseEnd = end;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _watch.stop();
    _ticker?.cancel();
    super.dispose();
  }
}

/// Original synthesized metronome loop: one brief tone then exact beat silence.
/// An entire eight-count phrase loops in the audio engine, not a Dart timer.
Uint8List makeMetronomeWav(int bpm) {
  if (bpm < 20 || bpm > 300) throw RangeError.range(bpm, 20, 300);
  const sampleRate = 22050;
  final samplesPerBeat = (sampleRate * 60 / bpm).round();
  final samples = samplesPerBeat * 8;
  final result = Uint8List(44 + samples * 2);
  final data = ByteData.sublistView(result);
  void text(int offset, String value) =>
      result.setRange(offset, offset + value.length, value.codeUnits);
  text(0, 'RIFF');
  data.setUint32(4, result.length - 8, Endian.little);
  text(8, 'WAVE');
  text(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, sampleRate, Endian.little);
  data.setUint32(28, sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  text(36, 'data');
  data.setUint32(40, samples * 2, Endian.little);
  const clickSamples = 660;
  for (var beat = 0; beat < 8; beat++) {
    for (var sample = 0; sample < clickSamples; sample++) {
      final tone = math.sin(
        2 * math.pi * (beat % 4 == 0 ? 1200 : 850) * sample / sampleRate,
      );
      final envelope = 1 - sample / clickSamples;
      data.setInt16(
        44 + (beat * samplesPerBeat + sample) * 2,
        (tone * envelope * 14000).round(),
        Endian.little,
      );
    }
  }
  return result;
}
