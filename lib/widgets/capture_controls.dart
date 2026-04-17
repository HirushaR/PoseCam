import 'package:flutter/material.dart';

class CaptureControls extends StatelessWidget {
  const CaptureControls({
    super.key,
    required this.onCapture,
    this.onGuide,
  });

  final VoidCallback onCapture;
  final VoidCallback? onGuide;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onGuide != null)
          IconButton(
            onPressed: onGuide,
            icon: const Icon(Icons.help_outline, color: Colors.white),
            tooltip: 'Guide',
          ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onCapture,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              color: Colors.white24,
            ),
            child: Center(
              child: Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const SizedBox(width: 48),
      ],
    );
  }
}
