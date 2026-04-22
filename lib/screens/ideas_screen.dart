import 'package:flutter/material.dart';

import 'camera_guide_screen.dart';
import 'vibe_screen.dart';

class IdeasScreen extends StatelessWidget {
  const IdeasScreen({
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
                  const Icon(Icons.account_circle_outlined, color: Color(0xFF46C9B0)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                children: [
                  Text(
                    'EXPLORE LIBRARY',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          letterSpacing: 1.1,
                          color: const Color(0xFF1B7667),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pose Gallery',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1C2022),
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Find your best angle with our curated collection of fun and aesthetic poses.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF50595E),
                        ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 42,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _FilterChip(label: 'All', selected: true),
                        SizedBox(width: 10),
                        _FilterChip(label: 'New'),
                        SizedBox(width: 10),
                        _FilterChip(label: 'Trending'),
                        SizedBox(width: 10),
                        _FilterChip(label: 'Studio'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FeatureCard(
                    title: 'The Cloud Walker',
                    subtitle: 'Effortless movement and airy vibes',
                    imageAsset: 'assets/poses/6.jpg',
                  ),
                  const SizedBox(height: 14),
                  _IdeasGrid(subjectName: subjectName),
                  const SizedBox(height: 110),
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
            _BottomTab(
              icon: Icons.explore_outlined,
              label: 'Explore',
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => VibeScreen(
                      subjectId: subjectId,
                      subjectName: subjectName,
                    ),
                  ),
                );
              },
            ),
            const _BottomTab(
              icon: Icons.auto_awesome_outlined,
              label: 'Ideas',
              selected: true,
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF1D7E70) : const Color(0xFFF5F6F7),
        border: Border.all(color: selected ? const Color(0xFF1D7E70) : const Color(0xFFD2D7D9)),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF485156),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  final String title;
  final String subtitle;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: Image.asset(
              imageAsset,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF4E575C),
                            ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFF0C9AD),
                  child: Icon(Icons.favorite_border, color: Color(0xFF835E4A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IdeasGrid extends StatelessWidget {
  const _IdeasGrid({required this.subjectName});

  final String subjectName;

  @override
  Widget build(BuildContext context) {
    final items = <_IdeaItem>[
      const _IdeaItem('Wink & Giggle', 'New', 'assets/poses/4.jpg'),
      const _IdeaItem('Over-the-Shoulder', 'Popular', 'assets/poses/5.jpg'),
      const _IdeaItem('The Thinker Chic', 'Portrait', 'assets/poses/1.jpg'),
      const _IdeaItem('Peaceful Energy', 'Lifestyle', 'assets/poses/2.jpg'),
      const _IdeaItem('The Executive', 'Professional', 'assets/poses/7.jpg'),
      const _IdeaItem('Sit & Stare', 'Sitting', 'assets/poses/8.jpg'),
    ];

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(item.imageAsset, fit: BoxFit.cover, width: double.infinity),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Text(
                          item.tag,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF5B656A),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD5ECEA),
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/poses/9.jpg',
                  height: 96,
                  width: 96,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EDITOR'S PICK",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            letterSpacing: 1,
                            color: const Color(0xFF2C766F),
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The Hair Flip',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      'Perfect for $subjectName.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF445052),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IdeaItem {
  const _IdeaItem(this.title, this.tag, this.imageAsset);

  final String title;
  final String tag;
  final String imageAsset;
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
