import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/toilet.dart';
import 'services/api_service.dart'; // Import the ApiService

// Define a StateNotifier to manage the state of toilets
class ToiletStateNotifier extends StateNotifier<List<Toilet>> {
  final ApiService _apiService; // Dependency on ApiService

  ToiletStateNotifier(this._apiService) : super([]) {
    fetchToilets(); // Fetch toilets when the provider is initialized
  }

  // Fetch toilet locations from the API
  Future<void> fetchToilets() async {
    try {
      final fetchedToilets = await _apiService.fetchToiletLocations();
      state = fetchedToilets.map<Toilet>((toiletData) {
        return Toilet.fromJson(toiletData); // Assuming Toilet has a fromJson method
      }).toList();
    } catch (e) {
      print('Error fetching toilets: $e');
    }
  }

  // Add a new toilet to the list and post it to the API
  Future<void> addToilet(Toilet toilet) async {
    try {
      await _apiService.addToiletLocation(toilet.toJson()); // Assuming Toilet has a toJson method
      state = [...state, toilet]; // Update the local state
    } catch (e) {
      print('Error adding toilet: $e');
    }
  }
}

// Define a Riverpod provider for ToiletStateNotifier
final toiletProvider = StateNotifierProvider<ToiletStateNotifier, List<Toilet>>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider); // Get the ApiService instance
    return ToiletStateNotifier(apiService);
  },
);

// Define an ApiService provider for dependency injection
final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(baseUrl: 'https://example.com/api'), // Replace with your API base URL
);
