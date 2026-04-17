import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/pose_data.dart';
import '../models/pose_item.dart';
import '../services/camera_service.dart';
import '../services/pose_detector_service.dart';
import '../services/pose_match_service.dart';
import '../utils/input_image_utils.dart';
import '../utils/landmark_utils.dart';
import '../widgets/capture_controls.dart';
import '../widgets/hint_banner.dart';
import '../widgets/pose_overlay_painter.dart';
import '../widgets/pose_thumbnail_list.dart';
import '../widgets/score_card.dart';
import '../widgets/skeleton_painter.dart';
import 'result_screen.dart';

class CameraGuideScreen extends StatefulWidget {
  const CameraGuideScreen({
    super.key,
    required this.categoryId,
    this.initialPoseId,
  });

  final String categoryId;
  final String? initialPoseId;

  @override
  State<CameraGuideScreen> createState() => _CameraGuideScreenState();
}

class _CameraGuideScreenState extends State<CameraGuideScreen>
    with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();
  final PoseDetectorService _poseDetector = PoseDetectorService();
  final PoseMatchService _poseMatch = PoseMatchService();

  List<PoseItem> _poses = [];
  late String _selectedPoseId;
  bool _loading = true;
  String? _error;

  Pose? _livePose;
  Size _imageSize = const Size(640, 480);
  InputImageRotation? _rotation;
  int _frameSkip = 0;
  bool _busy = false;

  int _score = 0;
  String _hint = '';
  bool _showScore = true;

  /// True when the last failure was missing camera permission (retry after Settings).
  bool _permissionError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _poses = posesForCategory(widget.categoryId);
    _selectedPoseId = widget.initialPoseId ??
        (_poses.isNotEmpty ? _poses.first.id : '');
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed &&
        mounted &&
        _permissionError) {
      setState(() {
        _loading = true;
        _error = null;
        _permissionError = false;
      });
      _bootstrap();
    }
  }

  Future<void> _bootstrap() async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.camera.request();
    }
    if (status.isPermanentlyDenied) {
      setState(() {
        _loading = false;
        _error =
            'Camera access is turned off. Open Settings to enable it for Pose Cam.';
        _permissionError = true;
      });
      return;
    }
    if (!status.isGranted) {
      setState(() {
        _loading = false;
        _error = 'Camera permission is required to use this screen.';
        _permissionError = true;
      });
      return;
    }
    _permissionError = false;

    try {
      await _cameraService.loadCameras();
      await _cameraService.initialize(
        initial: CameraLensDirection.back,
        preset: ResolutionPreset.high,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Could not open camera.';
      });
      return;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
    });
    await _startImageStream();
  }

  Future<void> _startImageStream() async {
    final controller = _cameraService.controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    await controller.startImageStream(_onCameraImage);
  }

  Future<void> _stopImageStream() async {
    final controller = _cameraService.controller;
    if (controller == null || !controller.value.isStreamingImages) {
      return;
    }
    await controller.stopImageStream();
  }

  Future<void> _onCameraImage(CameraImage image) async {
    _frameSkip++;
    if (_frameSkip % 3 != 0) {
      return;
    }
    if (_busy) {
      return;
    }
    final controller = _cameraService.controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    _busy = true;
    final desc = _cameraService.currentDescription;
    final input = inputImageFromCameraImage(image, controller, desc);
    if (input == null) {
      _busy = false;
      return;
    }
    final rot = computeInputImageRotation(controller, desc);
    final w = image.width.toDouble();
    final h = image.height.toDouble();
    try {
      final poses = await _poseDetector.processImage(input);
      if (!mounted) {
        return;
      }
      final pose = poses.isNotEmpty ? poses.first : null;
      final item = poseById(_selectedPoseId);
      PoseMatchResult match = const PoseMatchResult(score: 0);
      if (item != null) {
        match = _poseMatch.evaluate(pose, item);
      }
      setState(() {
        _livePose = pose;
        _imageSize = Size(w, h);
        _rotation = rot;
        _score = match.score;
        _hint = match.primaryFeedback?.message ?? '';
        if (match.noPersonDetected) {
          _hint = 'Step into the frame';
        }
      });
    } catch (_) {
      // Drop frame on transient ML errors.
    } finally {
      _busy = false;
    }
  }

  PoseItem? get _selectedPose => poseById(_selectedPoseId);

  Future<void> _switchCamera() async {
    await _stopImageStream();
    await _cameraService.switchCamera();
    await _startImageStream();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onCapture() async {
    final controller = _cameraService.controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    await _stopImageStream();
    try {
      final file = await controller.takePicture();
      final item = _selectedPose;
      final cat = categoryById(widget.categoryId);
      if (!mounted) {
        return;
      }
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => ResultScreen(
            imagePath: file.path,
            poseName: item?.name ?? 'Pose',
            categoryName: cat?.name ?? '',
            score: _showScore ? _score : null,
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not capture photo')),
        );
      }
    } finally {
      await _startImageStream();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.disposeAsync();
    unawaited(_poseDetector.close());
    super.dispose();
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  Future<void> _retryCamera() async {
    setState(() {
      _loading = true;
      _error = null;
      _permissionError = false;
    });
    await _bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    final category = categoryById(widget.categoryId);
    final controller = _cameraService.controller;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_off, size: 56, color: Colors.white54),
              const SizedBox(height: 24),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              if (_permissionError) ...[
                FilledButton.icon(
                  onPressed: _openAppSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text('Open Settings'),
                ),
                const SizedBox(height: 12),
              ],
              OutlinedButton.icon(
                onPressed: _retryCamera,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    if (_poses.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: const Center(child: Text('No poses for this category.')),
      );
    }
    if (controller == null || !controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: Text('Camera not ready')),
      );
    }

    final lens = controller.description.lensDirection;
    final mirror = lens == CameraLensDirection.front;
    final item = _selectedPose;

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final canvasSize = constraints.biggest;
          final rot = _rotation;
          final bonePaint = Paint()
            ..color = Colors.cyanAccent.withValues(alpha: 0.85)
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke;
          final jointPaint = Paint()..color = Colors.lightBlueAccent;

          final skeletonPoints = <PoseLandmarkType, Offset>{};
          if (_livePose != null && rot != null) {
            for (final e in _livePose!.landmarks.entries) {
              if (e.value.likelihood < kLandmarkLikelihoodThreshold) {
                continue;
              }
              skeletonPoints[e.key] = landmarkToPreview(
                e.value,
                canvasSize,
                _imageSize,
                rot,
                lens,
              );
            }
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller),
              CustomPaint(
                painter: PoseOverlayPainter(
                  normalizedPoints: item?.guideOutline ?? const [],
                  mirror: mirror,
                ),
              ),
              CustomPaint(
                painter: SkeletonPainter(
                  landmarks: skeletonPoints,
                  jointPaint: jointPaint,
                  bonePaint: bonePaint,
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          Expanded(
                            child: Text(
                              category?.name ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => _showScore = !_showScore);
                            },
                            icon: Icon(
                              _showScore
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                          ),
                          IconButton(
                            onPressed: _switchCamera,
                            icon: Icon(
                              Platform.isIOS
                                  ? Icons.flip_camera_ios_outlined
                                  : Icons.flip_camera_android_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: HintBanner(
                        message: _hint.isEmpty ? 'Match the outline' : _hint,
                        visible: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: ScoreCard(score: _score, visible: _showScore),
                    ),
                    const SizedBox(height: 12),
                    PoseThumbnailList(
                      poses: _poses,
                      selectedId: _selectedPoseId,
                      onSelect: (p) {
                        setState(() => _selectedPoseId = p.id);
                      },
                    ),
                    const SizedBox(height: 8),
                    CaptureControls(
                      onCapture: _onCapture,
                      onGuide: () {
                        showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Pose guide'),
                            content: const Text(
                              'Use the outline to align your body. '
                              'Switch poses with the strip below. '
                              'Hints update as you move.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
