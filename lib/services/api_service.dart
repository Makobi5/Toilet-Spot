// lib/services/api_service.dart

import 'dart:convert'; // For JSON encoding
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Fetch toilet locations from the API
  Future<List<Map<String, dynamic>>> fetchToiletLocations() async {
    final response = await http.get(Uri.parse('$baseUrl/toilets'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((toilet) => toilet as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load toilets');
    }
  }

  // Add a new toilet location by sending data to the API
  Future<void> addToiletLocation(Map<String, dynamic> toiletData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/toilets'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toiletData), // Convert toiletData map to JSON
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add toilet');
    }
  }
}
