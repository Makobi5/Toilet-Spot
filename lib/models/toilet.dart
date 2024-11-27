// lib/models/toilet.dart

class Toilet {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? rating;  // Rating for the toilet (optional)
  final String? cleanliness;  // Cleanliness status (optional)
  final String? accessibility;  // Accessibility status (optional)
  final List<Review>? reviews;  // List of reviews (optional)

  Toilet({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.cleanliness,
    this.accessibility,
    this.reviews,
  });

  // Factory method to create a Toilet object from JSON data
  factory Toilet.fromJson(Map<String, dynamic> json) {
    var reviewsList = json['reviews'] as List?;
    List<Review> reviews = reviewsList != null 
      ? reviewsList.map((review) => Review.fromJson(review)).toList() 
      : [];

    return Toilet(
      id: json['id'].toString(),
      name: json['title'],  // Use 'title' as the toilet name
      address: json['body'], // Use 'body' as the toilet address
      latitude: json['latitude']?.toDouble() ?? 37.7749,  // Default latitude
      longitude: json['longitude']?.toDouble() ?? -122.4194,  // Default longitude
      rating: json['rating']?.toDouble(),
      cleanliness: json['cleanliness'],
      accessibility: json['accessibility'],
      reviews: reviews,
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
      'rating': rating,
      'cleanliness': cleanliness,
      'accessibility': accessibility,
      'reviews': reviews?.map((review) => review.toJson()).toList(),
    };
  }
}

// Review model for storing reviews for each toilet
class Review {
  final String username;
  final String comment;
  final double rating;

  Review({
    required this.username,
    required this.comment,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      username: json['username'],
      comment: json['comment'],
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'comment': comment,
      'rating': rating,
    };
  }
}
