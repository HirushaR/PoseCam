import 'package:camera/camera.dart';

/// Owns [CameraController] lifecycle and lens selection.
class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _index = 0;
  ResolutionPreset _preset = ResolutionPreset.high;
  ImageFormatGroup? _formatGroup;

  CameraController? get controller => _controller;

  List<CameraDescription> get cameras => _cameras;

  CameraDescription get currentDescription => _cameras[_index];

  bool get isInitialized =>
      _controller != null && _controller!.value.isInitialized;

  Future<void> loadCameras() async {
    _cameras = await availableCameras();
  }

  /// [initial] defaults to back camera when available.
  Future<CameraController?> initialize({
    CameraLensDirection initial = CameraLensDirection.back,
    ResolutionPreset preset = ResolutionPreset.high,
    ImageFormatGroup? imageFormatGroup,
  }) async {
    if (_cameras.isEmpty) {
      await loadCameras();
    }
    if (_cameras.isEmpty) {
      return null;
    }

    _preset = preset;
    _formatGroup = imageFormatGroup;
    _index = 0;
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == initial) {
        _index = i;
        break;
      }
    }

    await _controller?.dispose();
    _controller = CameraController(
      _cameras[_index],
      _preset,
      enableAudio: false,
      imageFormatGroup: imageFormatGroup,
    );
    await _controller!.initialize();
    return _controller;
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) {
      return;
    }
    _index = (_index + 1) % _cameras.length;
    await _controller?.dispose();
    _controller = CameraController(
      _cameras[_index],
      _preset,
      enableAudio: false,
      imageFormatGroup: _formatGroup,
    );
    await _controller!.initialize();
  }

  /// Releases the camera. Safe to call from [State.dispose] (schedules async work).
  void disposeAsync() {
    final c = _controller;
    _controller = null;
    if (c == null) {
      return;
    }
    Future(() async {
      try {
        if (c.value.isStreamingImages) {
          await c.stopImageStream();
        }
      } catch (_) {}
      await c.dispose();
    });
  }
}
