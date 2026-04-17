import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.score,
    this.visible = true,
  });

  final int score;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, color: Colors.amberAccent, size: 20),
          const SizedBox(width: 6),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
