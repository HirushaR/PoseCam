import 'package:flutter/material.dart';

/// Draws a static normalized guide outline (Huawei-style ghost pose).
class PoseOverlayPainter extends CustomPainter {
  PoseOverlayPainter({
    required this.normalizedPoints,
    required this.mirror,
    this.lineColor = const Color(0x99FFFFFF),
    this.strokeWidth = 3,
    this.scale = 1.0,
  });

  final List<Offset> normalizedPoints;
  final bool mirror;
  final Color lineColor;
  final double strokeWidth;

  /// Uniform scale around the center of the preview (1 = default size).
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    if (normalizedPoints.length < 2) {
      return;
    }
    canvas.save();
    if (scale != 1.0) {
      final cx = size.width / 2;
      final cy = size.height / 2;
      canvas.translate(cx, cy);
      canvas.scale(scale);
      canvas.translate(-cx, -cy);
    }
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (var i = 0; i < normalizedPoints.length; i++) {
      var nx = normalizedPoints[i].dx;
      final ny = normalizedPoints[i].dy;
      if (mirror) {
        nx = 1.0 - nx;
      }
      final p = Offset(nx * size.width, ny * size.height);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, paint);

    final dot = Paint()..color = lineColor.withValues(alpha: 0.9);
    for (var i = 0; i < normalizedPoints.length; i++) {
      var nx = normalizedPoints[i].dx;
      final ny = normalizedPoints[i].dy;
      if (mirror) {
        nx = 1.0 - nx;
      }
      final p = Offset(nx * size.width, ny * size.height);
      canvas.drawCircle(p, 3, dot);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant PoseOverlayPainter oldDelegate) {
    return oldDelegate.normalizedPoints != normalizedPoints ||
        oldDelegate.mirror != mirror ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.scale != scale;
  }
}
