// lib/models/toilet.dart

class Toilet {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Toilet({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  // Factory method to create a Toilet object from JSON data
  factory Toilet.fromJson(Map<String, dynamic> json) {
    return Toilet(
      id: json['id'].toString(),
      name: json['title'],  // Use 'title' as the toilet name
      address: json['body'], // Use 'body' as the toilet address
      latitude: 37.7749,  // Placeholder latitude
      longitude: -122.4194, // Placeholder longitude
    );
  }

  // Method to convert a Toilet object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,  // 'name' will be mapped to 'title' for the API
      'body': address, // 'address' will be mapped to 'body'
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
