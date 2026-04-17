import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Maps ML Kit image coordinates to the camera preview canvas (see ML Kit sample).
double translateX(
  double x,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  CameraLensDirection cameraLensDirection,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x *
          canvasSize.width /
          (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation270deg:
      return canvasSize.width -
          x *
              canvasSize.width /
              (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      switch (cameraLensDirection) {
        case CameraLensDirection.back:
          return x * canvasSize.width / imageSize.width;
        case CameraLensDirection.front:
        case CameraLensDirection.external:
          return canvasSize.width - x * canvasSize.width / imageSize.width;
      }
  }
}

double translateY(
  double y,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  CameraLensDirection cameraLensDirection,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y *
          canvasSize.height /
          (Platform.isIOS ? imageSize.height : imageSize.width);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      return y * canvasSize.height / imageSize.height;
  }
}

Offset landmarkToPreview(
  PoseLandmark lm,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  CameraLensDirection lensDirection,
) {
  return Offset(
    translateX(lm.x, canvasSize, imageSize, rotation, lensDirection),
    translateY(lm.y, canvasSize, imageSize, rotation, lensDirection),
  );
}

const double kLandmarkLikelihoodThreshold = 0.25;

bool hasLikely(Pose pose, PoseLandmarkType type) {
  final lm = pose.landmarks[type];
  if (lm == null) {
    return false;
  }
  return lm.likelihood >= kLandmarkLikelihoodThreshold;
}
