import 'package:flutter/material.dart';

import '../data/pose_data.dart';
import '../models/pose_category.dart';
import 'vibe_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const Map<String, String> _imageForCategory = <String, String>{
    'man': 'assets/poses/1.jpg',
    'weman': 'assets/poses/4.jpg',
    'couples': 'assets/poses/7.jpg',
  };

  static const Map<String, String> _subtitleForCategory = <String, String>{
    'man': 'Dynamic, sharp,\nand structured\nposes',
    'weman': 'Fluid, elegant,\nand soft-angled\nposes',
    'couples': 'Intimate, playful,\nand storytelling\nposes',
  };

  static const Map<String, Color> _chipColorForCategory = <String, Color>{
    'man': Color(0xFF00BFA5),
    'weman': Color(0xFFFFB58A),
    'couples': Color(0xFF8AB4F8),
  };

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
                  const Icon(Icons.account_circle_outlined, color: Color(0xFF8A9499)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                children: [
                  Text(
                    'Who are we shooting?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1C2022),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your subject to see tailored pose ideas',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF5D676C),
                        ),
                  ),
                  const SizedBox(height: 22),
                  ...poseCategories.map((c) => _CategoryCard(
                        category: c,
                        imageAsset:
                            _imageForCategory[c.id] ?? 'assets/placeholders/placeholder.png',
                        subtitle:
                            _subtitleForCategory[c.id] ?? c.description,
                        accentColor:
                            _chipColorForCategory[c.id] ?? const Color(0xFF46C9B0),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => VibeScreen(
                                subjectId: c.id,
                                subjectName: c.name == 'Weman' ? 'Female' : c.name,
                              ),
                            ),
                          );
                        },
                      )),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFBFEDE2).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Color(0xFF12866F)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tip: You can always change your subject later.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF3B4848),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 112),
                ],
              ),
            ),
          ],
        ),
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
          children: const [
            _BottomTab(icon: Icons.explore_outlined, label: 'Explore', selected: true),
            _BottomTab(icon: Icons.auto_awesome_outlined, label: 'Ideas'),
            _BottomTab(icon: Icons.favorite_border, label: 'Saved'),
            _BottomTab(icon: Icons.person_outline, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.imageAsset,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  final PoseCategory category;
  final String imageAsset;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor.withValues(alpha: 0.25)),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        color: accentColor,
                        size: 38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name == 'Weman' ? 'Female' : category.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E2325),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF4E585D),
                              height: 1.35,
                            ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF7A8489)),
              ],
            ),
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
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF188F79);
    final inactiveColor = const Color(0xFF8A9499);
    return AnimatedContainer(
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
    );
  }
}
