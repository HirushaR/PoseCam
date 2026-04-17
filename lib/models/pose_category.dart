class PoseCategory {
  const PoseCategory({
    required this.id,
    required this.name,
    this.description = '',
  });

  final String id;
  final String name;
  final String description;
}
