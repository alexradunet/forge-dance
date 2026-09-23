import 'package:flutter/foundation.dart';

/// In-memory playback experiment, not lesson progress or a production teacher.
/// The host supplies frame deltas; no timers, IO or rendering live here.
class MotionLabController extends ChangeNotifier {
  static const clipSeconds = 8.0;
  static const speeds = [0.25, 0.5, 1.0];

  double _position = 0;
  double _speed = 1;
  double _yaw = 0;
  bool _playing = false;
  bool _loop = false;
  double get position => _position;
  double get speed => _speed;
  double get yaw => _yaw;
  bool get playing => _playing;
  bool get loop => _loop;
  // Deliberately bounded first experiment: loop the middle four seconds.
  double get rangeStart => _loop ? 0.25 : 0;
  double get rangeEnd => _loop ? 0.75 : 1;

  void togglePlayback() {
    if (_position >= rangeEnd || _position < rangeStart) _position = rangeStart;
    _playing = !_playing;
    notifyListeners();
  }

  void pause() {
    if (!_playing) return;
    _playing = false;
    notifyListeners();
  }

  void seek(double value) {
    if (!value.isFinite) return;
    _playing = false;
    _position = value.clamp(rangeStart, rangeEnd);
    notifyListeners();
  }

  void setSpeed(double value) {
    if (!speeds.contains(value)) return;
    _speed = value;
    notifyListeners();
  }

  void setLoop(bool value) {
    _loop = value;
    _position = _position.clamp(rangeStart, rangeEnd);
    notifyListeners();
  }

  void setYaw(double degrees) {
    if (!degrees.isFinite) return;
    _yaw = degrees.clamp(-180, 180);
    notifyListeners();
  }

  void advance(Duration delta) {
    if (!_playing || delta <= Duration.zero) return;
    _position +=
        delta.inMicroseconds /
        Duration.microsecondsPerSecond *
        _speed /
        clipSeconds;
    if (_position >= rangeEnd) {
      if (_loop) {
        _position =
            rangeStart + (_position - rangeStart) % (rangeEnd - rangeStart);
      } else {
        _position = rangeEnd;
        _playing = false;
      }
    }
    notifyListeners();
  }
}
