import 'dart:ui';

import 'pose_rule.dart';

/// One guided pose with optional target outline (normalized 0–1) and rules.
class PoseItem {
  const PoseItem({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.rules,
    required this.thumbnailAsset,
    required this.guideOutline,
  });

  final String id;
  final String name;
  final String categoryId;
  final List<PoseRule> rules;

  /// Asset path for thumbnail (placeholder for MVP).
  final String thumbnailAsset;

  /// Normalized polyline for static guide overlay (camera preview space).
  final List<Offset> guideOutline;
}
