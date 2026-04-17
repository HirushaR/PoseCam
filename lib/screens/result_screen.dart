import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.poseName,
    required this.categoryName,
    this.score,
  });

  final String imagePath;
  final String poseName;
  final String categoryName;
  final int? score;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      if (Platform.isAndroid) {
        final st = await Permission.storage.request();
        final photos = await Permission.photos.request();
        if (!st.isGranted && !photos.isGranted) {
          await Permission.photosAddOnly.request();
        }
      } else {
        await Permission.photosAddOnly.request();
      }
      final result = await ImageGallerySaverPlus.saveFile(
        widget.imagePath,
        name: 'pose_cam_${DateTime.now().millisecondsSinceEpoch}',
      );
      if (!mounted) {
        return;
      }
      final ok = result is Map && result['isSuccess'] == true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Saved to gallery' : 'Could not save'),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Save failed')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final file = File(widget.imagePath);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  file,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.poseName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (widget.categoryName.isNotEmpty)
                  Text(
                    widget.categoryName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                if (widget.score != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Score: ${widget.score}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Retake'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Photo'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
