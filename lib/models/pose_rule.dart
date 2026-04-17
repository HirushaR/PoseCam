import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// How a pose rule is evaluated against live landmarks.
enum PoseRuleKind {
  /// Interior angle at [vertex] between segments [towardA] and [towardB].
  jointAngle,

  /// Expect [higher]'s Y (image space, top = smaller Y) to be less than [lower]'s.
  verticalOrder,
}

/// A single check used for scoring and hint generation.
class PoseRule {
  const PoseRule({
    required this.id,
    required this.hintWhenFail,
    required this.kind,
    this.vertex,
    this.towardA,
    this.towardB,
    this.minDegrees = 0,
    this.maxDegrees = 180,
    this.higher,
    this.lower,
  });

  final String id;
  final String hintWhenFail;
  final PoseRuleKind kind;

  final PoseLandmarkType? vertex;
  final PoseLandmarkType? towardA;
  final PoseLandmarkType? towardB;
  final double minDegrees;
  final double maxDegrees;

  final PoseLandmarkType? higher;
  final PoseLandmarkType? lower;
}
