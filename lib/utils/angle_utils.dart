import 'dart:math' as math;
import 'dart:ui';

/// Interior angle at [vertex] between ([a] -> [vertex]) and ([c] -> [vertex]), degrees.
double angleAtVertexDeg(Offset a, Offset vertex, Offset c) {
  final v1 = a - vertex;
  final v2 = c - vertex;
  final len = v1.distance * v2.distance;
  if (len == 0) {
    return 0;
  }
  var cos = (v1.dx * v2.dx + v1.dy * v2.dy) / len;
  cos = cos.clamp(-1.0, 1.0);
  return math.acos(cos) * 180 / math.pi;
}
