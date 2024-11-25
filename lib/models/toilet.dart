class Toilet {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Toilet({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  // Factory method to create a Toilet from JSON
  factory Toilet.fromJson(Map<String, dynamic> json) {
    return Toilet(
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  // Method to convert a Toilet to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
