import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'services/location_service.dart'; // Assuming you have this service file

// Define the Riverpod provider for location
final locationProvider = StateProvider<Position?>((ref) => null);

void main() {
  runApp(const ProviderScope(child: MyApp())); // Wrap the app with ProviderScope
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toilet Spot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LocationScreen(),
    );
  }
}

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  final LocationService _locationService = LocationService();
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel(); // Cancel the subscription when the widget is disposed to avoid memory leaks
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      // Update the location using Riverpod provider
      ref.read(locationProvider.notifier).state = position;
    } catch (e) {
      print('Error: $e');
    }
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Minimum distance (in meters) to receive updates
      ),
    ).listen((Position position) {
      print('Updated Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      // Update the location using Riverpod provider
      ref.read(locationProvider.notifier).state = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the locationProvider to rebuild the widget when location updates
    final currentPosition = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Toilet Spot')),
      body: Center(
        child: currentPosition == null
            ? const CircularProgressIndicator()
            : Text(
                'Latitude: ${currentPosition.latitude}, '
                'Longitude: ${currentPosition.longitude}',
              ),
      ),
    );
  }
}
