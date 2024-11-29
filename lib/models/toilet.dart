class Toilet {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double rating;
  final bool isAccessible;
  final String description;

  Toilet({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.rating = 0.0,
    this.isAccessible = false,
    this.description = '',
  });
}