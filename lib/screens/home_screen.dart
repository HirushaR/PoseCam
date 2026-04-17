import 'package:flutter/material.dart';

import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pose Cam'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Text(
              'Guided poses',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Pick a category, match the outline, and capture your shot.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CategoryScreen(),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Start Session'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
