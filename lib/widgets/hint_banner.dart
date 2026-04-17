import 'package:flutter/material.dart';

class HintBanner extends StatelessWidget {
  const HintBanner({
    super.key,
    required this.message,
    this.visible = true,
  });

  final String message;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible || message.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
