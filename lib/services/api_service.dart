import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<dynamic>> fetchToiletLocations() async {
    final url = Uri.parse('$baseUrl/toilets');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load toilet locations');
    }
  }

  Future<void> addToiletLocation(Map<String, dynamic> toiletData) async {
    final url = Uri.parse('$baseUrl/toilets');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(toiletData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add toilet location');
    }
  }
}
