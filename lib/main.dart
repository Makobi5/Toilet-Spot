import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async'; // Import this for StreamSubscription
import 'services/location_service.dart'; // Adjust the path if necessary

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toilet Spot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _currentPosition;
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
      setState(() {
        _currentPosition = position;
      });
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
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Toilet Spot')),
      body: Center(
        child: _currentPosition == null
            ? CircularProgressIndicator()
            : Text(
                'Latitude: ${_currentPosition!.latitude}, '
                'Longitude: ${_currentPosition!.longitude}',
              ),
      ),
    );
  }
}
