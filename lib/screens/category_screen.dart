import 'package:flutter/material.dart';

import '../data/pose_data.dart';
import '../models/pose_category.dart';
import 'camera_guide_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose category'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: poseCategories.length,
        itemBuilder: (context, index) {
          final PoseCategory c = poseCategories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(c.name),
              subtitle: Text(c.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CameraGuideScreen(categoryId: c.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
