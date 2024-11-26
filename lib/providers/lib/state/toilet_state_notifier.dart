// lib/state/toilet_state_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toilet_spot/models/toilet.dart';
import 'package:toilet_spot/services/api_service.dart';

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
        return Toilet.fromJson(toiletData); // Convert API data to Toilet objects
      }).toList();
    } catch (e) {
      print('Error fetching toilets: $e');
    }
  }

  // Add a new toilet to the list and post it to the API
  Future<void> addToilet(Toilet toilet) async {
    try {
      await _apiService.addToiletLocation(toilet.toJson()); // Convert Toilet to JSON and post it
      state = [...state, toilet]; // Update the local state with the new toilet
    } catch (e) {
      print('Error adding toilet: $e');
    }
  }
}

// Define a Riverpod StateNotifierProvider for ToiletStateNotifier
final toiletProvider = StateNotifierProvider<ToiletStateNotifier, List<Toilet>>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider); // Get the ApiService instance
    return ToiletStateNotifier(apiService);
  },
);

// Define a FutureProvider to fetch toilets from the API
final toiletLocationsProvider = FutureProvider<List<Toilet>>((ref) async {
  final apiService = ref.watch(apiServiceProvider); // Get the ApiService instance
  final fetchedToilets = await apiService.fetchToiletLocations();

  // Convert API data to Toilet objects
  return fetchedToilets.map<Toilet>((toiletData) {
    return Toilet.fromJson(toiletData);
  }).toList();
});

// Define an ApiService provider for dependency injection
final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(baseUrl: 'https://jsonplaceholder.typicode.com'), // Replace with your actual API base URL
);
