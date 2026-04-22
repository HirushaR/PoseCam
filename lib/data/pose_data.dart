import 'dart:ui';

import '../models/pose_category.dart';
import '../models/pose_item.dart';
import '../models/pose_rule.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

const String kPlaceholderThumb = 'assets/placeholders/placeholder.png';

final List<PoseCategory> poseCategories = [
  const PoseCategory(
    id: 'man',
    name: 'Man',
    description: 'Solo poses for men.',
  ),
  const PoseCategory(
    id: 'weman',
    name: 'Weman',
    description: 'Solo poses for women.',
  ),
  const PoseCategory(
    id: 'couples',
    name: 'Couples',
    description: 'Pair and partner pose ideas.',
  ),
];

final List<PoseItem> poseItems = [
  // Man
  PoseItem(
    id: 'selfie_chin_tilt',
    name: 'Chin Tilt',
    categoryId: 'man',
    thumbnailAsset: kPlaceholderThumb,
    guideOutline: _outlineChinTilt(),
    rules: [
      const PoseRule(
        id: 'neck_angle',
        hintWhenFail: 'Tilt your chin down a little',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.nose,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.rightShoulder,
        minDegrees: 10,
        maxDegrees: 45,
      ),
      const PoseRule(
        id: 'elbows_soft',
        hintWhenFail: 'Relax your elbows slightly outward',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftElbow,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.leftWrist,
        minDegrees: 140,
        maxDegrees: 175,
      ),
      const PoseRule(
        id: 'face_level',
        hintWhenFail: 'Level your shoulders',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftShoulder,
        towardA: PoseLandmarkType.leftEar,
        towardB: PoseLandmarkType.rightShoulder,
        minDegrees: 80,
        maxDegrees: 100,
      ),
    ],
  ),
  PoseItem(
    id: 'selfie_soft_angle',
    name: 'Soft Angle',
    categoryId: 'man',
    thumbnailAsset: kPlaceholderThumb,
    guideOutline: _outlineSoftAngle(),
    rules: [
      const PoseRule(
        id: 'left_elbow',
        hintWhenFail: 'Bend your left arm slightly',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftElbow,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.leftWrist,
        minDegrees: 130,
        maxDegrees: 165,
      ),
      const PoseRule(
        id: 'right_elbow',
        hintWhenFail: 'Soften your right arm angle',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.rightElbow,
        towardA: PoseLandmarkType.rightShoulder,
        towardB: PoseLandmarkType.rightWrist,
        minDegrees: 130,
        maxDegrees: 165,
      ),
      const PoseRule(
        id: 'hips_visible',
        hintWhenFail: 'Show a bit more torso by angling your body',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftHip,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.rightHip,
        minDegrees: 160,
        maxDegrees: 195,
      ),
    ],
  ),
  PoseItem(
    id: 'selfie_overhead',
    name: 'Overhead Look',
    categoryId: 'man',
    thumbnailAsset: kPlaceholderThumb,
    guideOutline: _outlineOverhead(),
    rules: [
      const PoseRule(
        id: 'arms_up',
        hintWhenFail: 'Raise your arms higher above your head',
        kind: PoseRuleKind.verticalOrder,
        higher: PoseLandmarkType.leftWrist,
        lower: PoseLandmarkType.nose,
      ),
      const PoseRule(
        id: 'right_wrist_high',
        hintWhenFail: 'Lift your right hand',
        kind: PoseRuleKind.verticalOrder,
        higher: PoseLandmarkType.rightWrist,
        lower: PoseLandmarkType.rightShoulder,
      ),
      const PoseRule(
        id: 'elbow_open',
        hintWhenFail: 'Open your elbows wider',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftElbow,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.leftWrist,
        minDegrees: 140,
        maxDegrees: 180,
      ),
    ],
  ),
  // Weman
  PoseItem(
    id: 'nature_walk',
    name: 'Walk Pose',
    categoryId: 'weman',
    thumbnailAsset: kPlaceholderThumb,
    guideOutline: _outlineWalk(),
    rules: [
      const PoseRule(
        id: 'stride',
        hintWhenFail: 'Step one foot slightly forward',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftKnee,
        towardA: PoseLandmarkType.leftHip,
        towardB: PoseLandmarkType.leftAnkle,
        minDegrees: 160,
        maxDegrees: 185,
      ),
      const PoseRule(
        id: 'upright',
        hintWhenFail: 'Straighten your torso',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftHip,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.rightHip,
        minDegrees: 170,
        maxDegrees: 195,
      ),
      const PoseRule(
        id: 'relaxed_arms',
        hintWhenFail: 'Let arms swing naturally at your sides',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.rightElbow,
        towardA: PoseLandmarkType.rightShoulder,
        towardB: PoseLandmarkType.rightWrist,
        minDegrees: 155,
        maxDegrees: 185,
      ),
    ],
  ),
  PoseItem(
    id: 'nature_side_look',
    name: 'Side Look',
    categoryId: 'weman',
    thumbnailAsset: kPlaceholderThumb,
    guideOutline: _outlineSideLook(),
    rules: [
      const PoseRule(
        id: 'head_turn',
        hintWhenFail: 'Turn your head a bit more to the side',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.nose,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.rightShoulder,
        minDegrees: 5,
        maxDegrees: 40,
      ),
      const PoseRule(
        id: 'shoulder_line',
        hintWhenFail: 'Open your chest toward the camera',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.rightShoulder,
        towardA: PoseLandmarkType.rightHip,
        towardB: PoseLandmarkType.leftShoulder,
        minDegrees: 70,
        maxDegrees: 110,
      ),
      const PoseRule(
        id: 'weight_shift',
        hintWhenFail: 'Shift weight slightly to your back leg',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.rightKnee,
        towardA: PoseLandmarkType.rightHip,
        towardB: PoseLandmarkType.rightAnkle,
        minDegrees: 165,
        maxDegrees: 195,
      ),
    ],
  ),
  PoseItem(
    id: 'nature_hands_relaxed',
    name: 'Hands Relaxed',
    categoryId: 'weman',
    thumbnailAsset: kPlaceholderThumb,
    guideOutline: _outlineHandsRelaxed(),
    rules: [
      const PoseRule(
        id: 'hands_low',
        hintWhenFail: 'Lower your hands near your hips',
        kind: PoseRuleKind.verticalOrder,
        higher: PoseLandmarkType.leftShoulder,
        lower: PoseLandmarkType.leftWrist,
      ),
      const PoseRule(
        id: 'elbows_soft',
        hintWhenFail: 'Soften your elbow bend',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftElbow,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.leftWrist,
        minDegrees: 150,
        maxDegrees: 180,
      ),
      const PoseRule(
        id: 'symmetry',
        hintWhenFail: 'Balance both sides similarly',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.rightElbow,
        towardA: PoseLandmarkType.rightShoulder,
        towardB: PoseLandmarkType.rightWrist,
        minDegrees: 150,
        maxDegrees: 180,
      ),
    ],
  ),
  // Couples
  PoseItem(
    id: 'grad_cap_raise',
    name: 'Cap Raise',
    categoryId: 'couples',
    thumbnailAsset: kPlaceholderThumb,
    guideOutline: _outlineCapRaise(),
    rules: [
      const PoseRule(
        id: 'wrist_high',
        hintWhenFail: 'Raise your hand toward the cap',
        kind: PoseRuleKind.verticalOrder,
        higher: PoseLandmarkType.rightWrist,
        lower: PoseLandmarkType.rightShoulder,
      ),
      const PoseRule(
        id: 'elbow_bent',
        hintWhenFail: 'Bend your arm to lift the cap',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.rightElbow,
        towardA: PoseLandmarkType.rightShoulder,
        towardB: PoseLandmarkType.rightWrist,
        minDegrees: 60,
        maxDegrees: 130,
      ),
      const PoseRule(
        id: 'smile_posture',
        hintWhenFail: 'Stand tall with level shoulders',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftShoulder,
        towardA: PoseLandmarkType.leftEar,
        towardB: PoseLandmarkType.rightShoulder,
        minDegrees: 85,
        maxDegrees: 100,
      ),
    ],
  ),
  PoseItem(
    id: 'grad_certificate',
    name: 'Certificate Hold',
    categoryId: 'couples',
    thumbnailAsset: kPlaceholderThumb,
    guideOutline: _outlineCertificate(),
    rules: [
      const PoseRule(
        id: 'hands_mid',
        hintWhenFail: 'Hold hands near chest height',
        kind: PoseRuleKind.verticalOrder,
        higher: PoseLandmarkType.nose,
        lower: PoseLandmarkType.leftWrist,
      ),
      const PoseRule(
        id: 'left_elbow',
        hintWhenFail: 'Bend your left elbow to frame the certificate',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftElbow,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.leftWrist,
        minDegrees: 70,
        maxDegrees: 130,
      ),
      const PoseRule(
        id: 'right_elbow',
        hintWhenFail: 'Mirror your right arm',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.rightElbow,
        towardA: PoseLandmarkType.rightShoulder,
        towardB: PoseLandmarkType.rightWrist,
        minDegrees: 70,
        maxDegrees: 130,
      ),
    ],
  ),
  PoseItem(
    id: 'grad_side_smile',
    name: 'Side Smile',
    categoryId: 'couples',
    thumbnailAsset: kPlaceholderThumb,
    guideOutline: _outlineSideSmile(),
    rules: [
      const PoseRule(
        id: 'three_quarter',
        hintWhenFail: 'Angle your shoulders slightly from the camera',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftHip,
        towardA: PoseLandmarkType.leftShoulder,
        towardB: PoseLandmarkType.rightHip,
        minDegrees: 165,
        maxDegrees: 200,
      ),
      const PoseRule(
        id: 'chin_lift',
        hintWhenFail: 'Lift your chin slightly',
        kind: PoseRuleKind.verticalOrder,
        higher: PoseLandmarkType.nose,
        lower: PoseLandmarkType.leftShoulder,
      ),
      const PoseRule(
        id: 'relaxed_hands',
        hintWhenFail: 'Keep hands relaxed at your side',
        kind: PoseRuleKind.jointAngle,
        vertex: PoseLandmarkType.leftWrist,
        towardA: PoseLandmarkType.leftElbow,
        towardB: PoseLandmarkType.leftIndex,
        minDegrees: 130,
        maxDegrees: 180,
      ),
    ],
  ),
  ...List<PoseItem>.generate(9, (i) {
    final n = i + 1;
    final categoryId = n <= 3
        ? 'man'
        : (n <= 6 ? 'weman' : 'couples');
    return PoseItem(
      id: 'ref_pose_$n',
      name: 'Pose $n',
      categoryId: categoryId,
      thumbnailAsset: 'assets/poses/$n.jpg',
      outlineImageAsset: 'assets/outlines/$n.png',
      guideOutline: const [],
      rules: const [],
    );
  }),
];

List<PoseItem> posesForCategory(String categoryId) {
  return poseItems.where((p) => p.categoryId == categoryId).toList();
}

PoseItem? poseById(String? id) {
  if (id == null || id.isEmpty) {
    return null;
  }
  try {
    return poseItems.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}

PoseCategory? categoryById(String id) {
  try {
    return poseCategories.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

// --- Normalized guide outlines (rough stick figures, portrait) ---

List<Offset> _baseBody() {
  return [
    const Offset(0.50, 0.12), // head top
    const Offset(0.50, 0.18), // neck
    const Offset(0.42, 0.22), // L shoulder
    const Offset(0.58, 0.22), // R shoulder
    const Offset(0.50, 0.38), // mid torso
    const Offset(0.42, 0.40), // L hip
    const Offset(0.58, 0.40), // R hip
    const Offset(0.44, 0.58), // L knee
    const Offset(0.56, 0.58), // R knee
    const Offset(0.44, 0.78), // L ankle
    const Offset(0.56, 0.78), // R ankle
  ];
}

List<Offset> _outlineChinTilt() {
  final b = _baseBody();
  return [
    b[0],
    b[1],
    const Offset(0.52, 0.17), // chin tilt
    b[2],
    b[3],
    const Offset(0.38, 0.32),
    const Offset(0.62, 0.32),
    b[6],
    b[7],
    b[8],
    b[9],
    b[10],
  ];
}

List<Offset> _outlineSoftAngle() {
  return [
    const Offset(0.48, 0.12),
    const Offset(0.48, 0.18),
    const Offset(0.40, 0.23),
    const Offset(0.56, 0.21),
    const Offset(0.46, 0.36),
    const Offset(0.40, 0.42),
    const Offset(0.54, 0.40),
    const Offset(0.42, 0.58),
    const Offset(0.54, 0.58),
    const Offset(0.44, 0.78),
    const Offset(0.54, 0.78),
  ];
}

List<Offset> _outlineOverhead() {
  return [
    const Offset(0.50, 0.14),
    const Offset(0.50, 0.20),
    const Offset(0.38, 0.16), // L arm up
    const Offset(0.62, 0.16), // R arm up
    const Offset(0.42, 0.24),
    const Offset(0.58, 0.24),
    const Offset(0.50, 0.38),
    const Offset(0.42, 0.42),
    const Offset(0.58, 0.42),
    const Offset(0.44, 0.58),
    const Offset(0.56, 0.58),
    const Offset(0.44, 0.78),
    const Offset(0.56, 0.78),
  ];
}

List<Offset> _outlineWalk() {
  return [
    const Offset(0.50, 0.12),
    const Offset(0.50, 0.18),
    const Offset(0.42, 0.23),
    const Offset(0.58, 0.23),
    const Offset(0.48, 0.36),
    const Offset(0.40, 0.42),
    const Offset(0.54, 0.40),
    const Offset(0.46, 0.55), // forward knee
    const Offset(0.54, 0.60),
    const Offset(0.44, 0.76),
    const Offset(0.54, 0.78),
  ];
}

List<Offset> _outlineSideLook() {
  return [
    const Offset(0.52, 0.12),
    const Offset(0.54, 0.18),
    const Offset(0.44, 0.22),
    const Offset(0.56, 0.21),
    const Offset(0.48, 0.36),
    const Offset(0.40, 0.42),
    const Offset(0.54, 0.40),
    const Offset(0.44, 0.58),
    const Offset(0.56, 0.58),
    const Offset(0.44, 0.78),
    const Offset(0.56, 0.78),
  ];
}

List<Offset> _outlineHandsRelaxed() {
  return [
    const Offset(0.50, 0.12),
    const Offset(0.50, 0.18),
    const Offset(0.42, 0.23),
    const Offset(0.58, 0.23),
    const Offset(0.40, 0.34),
    const Offset(0.60, 0.34),
    const Offset(0.50, 0.38),
    const Offset(0.42, 0.42),
    const Offset(0.58, 0.42),
    const Offset(0.44, 0.58),
    const Offset(0.56, 0.58),
    const Offset(0.44, 0.78),
    const Offset(0.56, 0.78),
  ];
}

List<Offset> _outlineCapRaise() {
  return [
    const Offset(0.50, 0.10),
    const Offset(0.50, 0.18),
    const Offset(0.42, 0.23),
    const Offset(0.58, 0.22),
    const Offset(0.58, 0.08), // arm up
    const Offset(0.50, 0.38),
    const Offset(0.42, 0.42),
    const Offset(0.58, 0.42),
    const Offset(0.44, 0.58),
    const Offset(0.56, 0.58),
    const Offset(0.44, 0.78),
    const Offset(0.56, 0.78),
  ];
}

List<Offset> _outlineCertificate() {
  return [
    const Offset(0.50, 0.12),
    const Offset(0.50, 0.18),
    const Offset(0.42, 0.24),
    const Offset(0.58, 0.24),
    const Offset(0.44, 0.36), // hands center
    const Offset(0.56, 0.36),
    const Offset(0.50, 0.40),
    const Offset(0.42, 0.44),
    const Offset(0.58, 0.44),
    const Offset(0.44, 0.58),
    const Offset(0.56, 0.58),
    const Offset(0.44, 0.78),
    const Offset(0.56, 0.78),
  ];
}

List<Offset> _outlineSideSmile() {
  return [
    const Offset(0.52, 0.12),
    const Offset(0.52, 0.18),
    const Offset(0.44, 0.23),
    const Offset(0.56, 0.22),
    const Offset(0.46, 0.36),
    const Offset(0.42, 0.42),
    const Offset(0.54, 0.40),
    const Offset(0.44, 0.58),
    const Offset(0.56, 0.58),
    const Offset(0.44, 0.78),
    const Offset(0.56, 0.78),
  ];
}
