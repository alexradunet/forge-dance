import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/movement_teacher/prototype/model/motion_lab_controller.dart';
import 'package:forge_dance/features/movement_teacher/prototype/model/synthetic_rig.dart';

void main() {
  late MotionLabController player;
  setUp(() => player = MotionLabController());
  tearDown(() => player.dispose());

  test('starts paused and only explicit playback advances the clip', () {
    player.advance(const Duration(seconds: 1));
    expect(player.position, 0);
    player.togglePlayback();
    player.advance(const Duration(seconds: 2));
    expect(player.position, 0.25);
    player.pause();
    player.advance(const Duration(seconds: 2));
    expect(player.position, 0.25);
  });

  test('speed scales time, seeking pauses and full playback ends', () {
    player.setSpeed(0.5);
    player.togglePlayback();
    player.advance(const Duration(seconds: 2));
    expect(player.position, 0.125);
    player.seek(0.8);
    expect(player.playing, isFalse);
    player.togglePlayback();
    player.advance(const Duration(seconds: 10));
    expect(player.position, 1);
    expect(player.playing, isFalse);
    player.togglePlayback();
    expect(player.position, 0);
  });

  test('short loop wraps overshoot and remains bounded on long frames', () {
    player.setLoop(true);
    expect(player.position, 0.25);
    player.togglePlayback();
    player.advance(const Duration(seconds: 5));
    expect(player.position, closeTo(0.375, 0.0001));
    player.advance(const Duration(hours: 2));
    expect(player.position, inInclusiveRange(0.25, 0.75));
    expect(player.playing, isTrue);
    player.seek(1);
    expect(player.position, 0.75);
    expect(player.playing, isFalse);
    player.setLoop(false);
    expect(player.rangeStart, 0);
    expect(player.rangeEnd, 1);
  });

  test('invalid values cannot corrupt timeline or camera', () {
    player.seek(double.nan);
    player.setYaw(double.infinity);
    player.setSpeed(-1);
    expect(player.position, 0);
    expect(player.yaw, 0);
    expect(player.speed, 1);
    player.setYaw(270);
    expect(player.yaw, 180);
    player.togglePlayback();
    player.advance(const Duration(seconds: -1));
    expect(player.position, 0);
  });

  test('synthetic rig samples are finite and loop to the original pose', () {
    for (final time in [0.0, 0.125, 0.5, 0.99, 1.0]) {
      final pose = SyntheticRig.sample(time);
      expect(pose.bones, hasLength(15));
      for (final bone in pose.bones) {
        for (final point in [bone.from, bone.to]) {
          expect(
            point.x.isFinite && point.y.isFinite && point.z.isFinite,
            isTrue,
          );
          expect(point.y, greaterThanOrEqualTo(0));
        }
      }
    }
    expect(
      SyntheticRig.sample(1).head.x,
      closeTo(SyntheticRig.sample(0).head.x, 1e-10),
    );
  });
}
