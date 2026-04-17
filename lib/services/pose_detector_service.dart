import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Wraps ML Kit pose detector lifecycle.
class PoseDetectorService {
  PoseDetectorService() {
    _detector = PoseDetector(
      options: PoseDetectorOptions(
        model: PoseDetectionModel.base,
        mode: PoseDetectionMode.stream,
      ),
    );
  }

  late final PoseDetector _detector;

  Future<List<Pose>> processImage(InputImage image) {
    return _detector.processImage(image);
  }

  Future<void> close() => _detector.close();
}
