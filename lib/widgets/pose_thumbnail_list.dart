import 'package:flutter/material.dart';

import '../models/pose_item.dart';

class PoseThumbnailList extends StatelessWidget {
  const PoseThumbnailList({
    super.key,
    required this.poses,
    required this.selectedId,
    required this.onNoneTap,
    required this.onPoseTap,
  });

  final List<PoseItem> poses;
  final String? selectedId;
  final VoidCallback onNoneTap;
  final ValueChanged<PoseItem> onPoseTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: poses.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final noneSelected = selectedId == null;
            return GestureDetector(
              onTap: onNoneTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: noneSelected ? Colors.amberAccent : Colors.white24,
                    width: noneSelected ? 3 : 1,
                  ),
                  color: Colors.black45,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.hide_image_outlined,
                        color: noneSelected ? Colors.amberAccent : Colors.white54,
                        size: 28,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        'None',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              noneSelected ? Colors.amberAccent : Colors.white70,
                          fontSize: 10,
                          fontWeight:
                              noneSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final pose = poses[index - 1];
          final selected = pose.id == selectedId;
          return GestureDetector(
            onTap: () => onPoseTap(pose),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? Colors.amberAccent : Colors.white24,
                  width: selected ? 3 : 1,
                ),
                color: Colors.black45,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      pose.thumbnailAsset,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      pose.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected ? Colors.amberAccent : Colors.white70,
                        fontSize: 10,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
