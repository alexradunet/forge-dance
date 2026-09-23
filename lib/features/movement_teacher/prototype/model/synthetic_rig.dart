import 'dart:math' as math;

/// Original procedural coordinates in metres, NOT captured or validated dance.
/// Y is up, +Z is the mannequin's front, +X is its anatomical left.
class RigPoint {
  const RigPoint(this.x, this.y, this.z);
  final double x;
  final double y;
  final double z;
}

class RigBone {
  const RigBone(this.from, this.to, {this.left = false, this.radius = 0.055});
  final RigPoint from;
  final RigPoint to;
  final bool left;
  final double radius;
}

class SyntheticRig {
  const SyntheticRig(this.bones, this.head);
  final List<RigBone> bones;
  final RigPoint head;

  static SyntheticRig sample(double position) {
    final phase = position * math.pi * 4;
    final sway = math.sin(phase) * 0.16;
    final bob = math.cos(phase * 2) * 0.035;
    final neck = RigPoint(sway, 1.5 + bob, 0);
    final hips = RigPoint(sway, 0.92 + bob, 0);
    final bones = <RigBone>[RigBone(hips, neck, radius: 0.14)];
    for (final side in [-1.0, 1.0]) {
      final swing = math.sin(phase + (side < 0 ? math.pi : 0));
      final shoulder = RigPoint(sway + side * 0.23, 1.43 + bob, 0);
      final elbow = RigPoint(sway + side * 0.32, 1.13 + bob, swing * 0.12);
      final wrist = RigPoint(
        sway + side * 0.4,
        0.99 + bob,
        0.18 + swing * 0.17,
      );
      final hip = RigPoint(sway + side * 0.13, 0.92 + bob, 0);
      final knee = RigPoint(side * 0.19 + sway * 0.5, 0.52 + bob, 0.10);
      final ankle = RigPoint(
        side * (0.22 + math.max(0, swing) * 0.13),
        0.09,
        0,
      );
      final toe = RigPoint(ankle.x, 0.06, 0.18);
      for (final pair in [
        (neck, shoulder),
        (shoulder, elbow),
        (elbow, wrist),
        (hips, hip),
        (hip, knee),
        (knee, ankle),
        (ankle, toe),
      ]) {
        bones.add(RigBone(pair.$1, pair.$2, left: side > 0));
      }
    }
    return SyntheticRig(bones, RigPoint(sway, 1.69 + bob, 0));
  }
}
