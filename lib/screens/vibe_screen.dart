import 'package:flutter/material.dart';

import 'camera_guide_screen.dart';
import 'ideas_screen.dart';

class VibeScreen extends StatelessWidget {
  const VibeScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  final String subjectId;
  final String subjectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F6),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Row(
                children: [
                  const Icon(Icons.bubble_chart_rounded, color: Color(0xFF46C9B0)),
                  const SizedBox(width: 8),
                  Text(
                    'Pose Pal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF46C9B0),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  const Icon(Icons.search, color: Color(0xFF8A9499)),
                  const SizedBox(width: 12),
                  const Icon(Icons.account_circle_outlined, color: Color(0xFF8A9499)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                children: [
                  Text(
                    'Pick a Vibe',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1C2022),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose a category to find your perfect pose',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF5D676C),
                        ),
                  ),
                  const SizedBox(height: 18),
                  _VibeCard(
                    title: 'Outdoor',
                    chip: 'Fresh Air',
                    imageAsset: 'assets/poses/5.jpg',
                    trailingIcon: Icons.park_outlined,
                    onTap: () => _openCamera(context),
                  ),
                  const SizedBox(height: 14),
                  _VibeCard(
                    title: 'Indoor',
                    chip: 'Home Vibes',
                    imageAsset: 'assets/poses/8.jpg',
                    trailingIcon: Icons.photo_camera_outlined,
                    onTap: () => _openCamera(context),
                  ),
                  const SizedBox(height: 14),
                  _VibeCard(
                    title: 'Selfie',
                    chip: 'Me Time',
                    imageAsset: 'assets/poses/2.jpg',
                    trailingIcon: Icons.person_outline,
                    onTap: () => _openCamera(context),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CD7C1),
                      borderRadius: BorderRadius.circular(34),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trending Poses',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1C5B52),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Popular picks for $subjectName right now.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFF205F56),
                              ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            CircleAvatar(radius: 12, backgroundImage: AssetImage('assets/poses/1.jpg')),
                            SizedBox(width: 6),
                            CircleAvatar(radius: 12, backgroundImage: AssetImage('assets/poses/4.jpg')),
                            SizedBox(width: 6),
                            CircleAvatar(radius: 12, backgroundImage: AssetImage('assets/poses/7.jpg')),
                            SizedBox(width: 8),
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.white,
                              child: Text(
                                '+2k',
                                style: TextStyle(
                                  color: Color(0xFF1D6E62),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 106),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCamera(context),
        backgroundColor: const Color(0xFF1D7E70),
        foregroundColor: Colors.white,
        child: const Icon(Icons.photo_camera_outlined),
      ),
      bottomNavigationBar: Container(
        height: 88,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const _BottomTab(
              icon: Icons.explore_outlined,
              label: 'Explore',
              selected: true,
            ),
            _BottomTab(
              icon: Icons.auto_awesome_outlined,
              label: 'Ideas',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => IdeasScreen(
                      subjectId: subjectId,
                      subjectName: subjectName,
                    ),
                  ),
                );
              },
            ),
            const _BottomTab(icon: Icons.favorite_border, label: 'Saved'),
            const _BottomTab(icon: Icons.person_outline, label: 'Profile'),
          ],
        ),
      ),
    );
  }

  void _openCamera(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CameraGuideScreen(categoryId: subjectId),
      ),
    );
  }
}

class _VibeCard extends StatelessWidget {
  const _VibeCard({
    required this.title,
    required this.chip,
    required this.imageAsset,
    required this.trailingIcon,
    required this.onTap,
  });

  final String title;
  final String chip;
  final String imageAsset;
  final IconData trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const ColoredBox(color: Color(0xFFE8EBEC)),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x22000000), Color(0xAA000000)],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 52,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB9EFE1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Text(
                    chip,
                    style: const TextStyle(
                      color: Color(0xFF0E5048),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                bottom: 16,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xAA355432),
                  child: Icon(trailingIcon, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomTab extends StatelessWidget {
  const _BottomTab({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF188F79);
    final inactiveColor = const Color(0xFF8A9499);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE6F7F2) : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? activeColor : inactiveColor, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected ? activeColor : inactiveColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
