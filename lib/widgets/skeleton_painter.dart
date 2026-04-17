import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Live skeleton from ML Kit landmarks in preview coordinates.
class SkeletonPainter extends CustomPainter {
  SkeletonPainter({
    required this.landmarks,
    required this.jointPaint,
    required this.bonePaint,
  });

  final Map<PoseLandmarkType, Offset> landmarks;
  final Paint jointPaint;
  final Paint bonePaint;

  static final List<(PoseLandmarkType, PoseLandmarkType)> _bones = [
    (PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder),
    (PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow),
    (PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist),
    (PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow),
    (PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist),
    (PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip),
    (PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip),
    (PoseLandmarkType.leftHip, PoseLandmarkType.rightHip),
    (PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee),
    (PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle),
    (PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee),
    (PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle),
    (PoseLandmarkType.nose, PoseLandmarkType.leftShoulder),
    (PoseLandmarkType.nose, PoseLandmarkType.rightShoulder),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final (a, b) in _bones) {
      final pa = landmarks[a];
      final pb = landmarks[b];
      if (pa != null && pb != null) {
        canvas.drawLine(pa, pb, bonePaint);
      }
    }
    for (final o in landmarks.values) {
      canvas.drawCircle(o, 4, jointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SkeletonPainter oldDelegate) {
    return oldDelegate.landmarks != landmarks;
  }
}
