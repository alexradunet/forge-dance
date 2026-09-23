import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../model/synthetic_rig.dart';

/// CPU projection of a small 3D rig, drawn with Flutter Canvas. This tests the
/// interaction, NOT GPU skinning, GLB loading, animation fidelity or performance.
class SyntheticRigPainter extends CustomPainter {
  const SyntheticRigPainter({
    required this.position,
    required this.yaw,
    required this.foreground,
    required this.accent,
    required this.floor,
  });

  final double position;
  final double yaw;
  final Color foreground;
  final Color accent;
  final Color floor;

  @override
  void paint(Canvas canvas, Size size) {
    final radians = yaw * math.pi / 180;
    final scale = math.min(size.width * 0.43, size.height * 0.46);
    RigPoint rotate(RigPoint point) => RigPoint(
      point.x * math.cos(radians) + point.z * math.sin(radians),
      point.y,
      -point.x * math.sin(radians) + point.z * math.cos(radians),
    );
    Offset project(RigPoint point) {
      final p = rotate(point);
      final perspective = 4 / (4 - p.z);
      return Offset(
        size.width / 2 + p.x * scale * perspective,
        size.height * 0.87 - (p.y + p.z * 0.24) * scale * perspective,
      );
    }

    final grid = Paint()
      ..color = floor
      ..strokeWidth = 1;
    for (var i = -4; i <= 4; i++) {
      final value = i * 0.3;
      canvas.drawLine(
        project(RigPoint(value, 0, -1.2)),
        project(RigPoint(value, 0, 1.2)),
        grid,
      );
      canvas.drawLine(
        project(RigPoint(-1.2, 0, value)),
        project(RigPoint(1.2, 0, value)),
        grid,
      );
    }
    final rig = SyntheticRig.sample(position);
    final bones = [...rig.bones]
      ..sort(
        (a, b) => (rotate(a.from).z + rotate(a.to).z).compareTo(
          rotate(b.from).z + rotate(b.to).z,
        ),
      );
    for (final bone in bones) {
      final a = project(bone.from);
      final b = project(bone.to);
      final depth = (rotate(bone.from).z + rotate(bone.to).z) / 2;
      final width = bone.radius * 2 * scale * 4 / (4 - depth);
      final color = bone.left ? accent : foreground;
      canvas.drawLine(
        a,
        b,
        Paint()
          ..color = color
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
      // Small joints preserve articulation without lighting-dependent legibility.
      canvas.drawCircle(b, width * 0.28, Paint()..color = color);
    }
    final head = project(rig.head);
    canvas.drawCircle(head, scale * 0.115, Paint()..color = foreground);
    // Nose identifies the facing direction; the body is never silently mirrored.
    canvas.drawLine(
      head,
      project(RigPoint(rig.head.x, rig.head.y, 0.18)),
      Paint()
        ..color = accent
        ..strokeWidth = scale * 0.04
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(SyntheticRigPainter oldDelegate) =>
      position != oldDelegate.position ||
      yaw != oldDelegate.yaw ||
      foreground != oldDelegate.foreground ||
      accent != oldDelegate.accent ||
      floor != oldDelegate.floor;
}
