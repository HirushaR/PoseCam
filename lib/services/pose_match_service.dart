import 'dart:ui';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../models/pose_feedback.dart';
import '../models/pose_item.dart';
import '../models/pose_rule.dart';
import '../utils/angle_utils.dart';
import '../utils/landmark_utils.dart';

class PoseMatchResult {
  const PoseMatchResult({
    required this.score,
    this.primaryFeedback,
    this.noPersonDetected = false,
  });

  /// 0–100 aggregate match quality.
  final int score;
  final PoseFeedback? primaryFeedback;
  final bool noPersonDetected;
}

class PoseMatchService {
  PoseMatchResult evaluate(Pose? pose, PoseItem target) {
    if (pose == null || pose.landmarks.length < 8) {
      return const PoseMatchResult(
        score: 0,
        primaryFeedback: PoseFeedback(
          message: 'Step into the frame',
          ruleId: 'presence',
        ),
        noPersonDetected: true,
      );
    }

    final rules = target.rules;
    if (rules.isEmpty) {
      return const PoseMatchResult(score: 100);
    }

    var passed = 0;
    PoseFeedback? firstFail;

    for (final rule in rules) {
      final ok = _evaluateRule(pose, rule);
      if (ok) {
        passed++;
      } else {
        firstFail ??= PoseFeedback(
          message: rule.hintWhenFail,
          ruleId: rule.id,
        );
      }
    }

    final score = ((passed / rules.length) * 100).round().clamp(0, 100);
    return PoseMatchResult(score: score, primaryFeedback: firstFail);
  }

  bool _evaluateRule(Pose pose, PoseRule rule) {
    switch (rule.kind) {
      case PoseRuleKind.jointAngle:
        return _angleRule(pose, rule);
      case PoseRuleKind.verticalOrder:
        return _verticalRule(pose, rule);
    }
  }

  bool _angleRule(Pose pose, PoseRule rule) {
    final v = rule.vertex;
    final a = rule.towardA;
    final b = rule.towardB;
    if (v == null || a == null || b == null) {
      return true;
    }
    if (!hasLikely(pose, v) ||
        !hasLikely(pose, a) ||
        !hasLikely(pose, b)) {
      return false;
    }
    final pV = _offset(pose.landmarks[v]!);
    final pA = _offset(pose.landmarks[a]!);
    final pB = _offset(pose.landmarks[b]!);
    final deg = angleAtVertexDeg(pA, pV, pB);
    return deg >= rule.minDegrees && deg <= rule.maxDegrees;
  }

  bool _verticalRule(Pose pose, PoseRule rule) {
    final hi = rule.higher;
    final lo = rule.lower;
    if (hi == null || lo == null) {
      return true;
    }
    if (!hasLikely(pose, hi) || !hasLikely(pose, lo)) {
      return false;
    }
    final yHi = pose.landmarks[hi]!.y;
    final yLo = pose.landmarks[lo]!.y;
    return yHi < yLo;
  }

  static Offset _offset(PoseLandmark lm) => Offset(lm.x, lm.y);
}
