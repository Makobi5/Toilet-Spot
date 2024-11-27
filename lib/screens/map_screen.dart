import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'; // For getting current location
import 'package:toilet_spot/models/toilet.dart'; // Your Toilet model

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {}; // To hold the markers on the map
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Fetch the current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle accordingly
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        // Permissions are denied, handle accordingly
        return;
      }
    }

    // Get the current position of the user
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    // Update map with user's location and nearby toilets
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("user_location"),
          position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          infoWindow: InfoWindow(title: "Your Location"),
        ),
      );
    });
  }

  // Add markers for nearby toilets (for now using mock data)
  void _addToiletMarkers() {
    List<Toilet> toilets = [
      Toilet(id: "1", name: "Toilet 1", address: "Street 1", latitude: 37.7749, longitude: -122.4194),
      Toilet(id: "2", name: "Toilet 2", address: "Street 2", latitude: 37.7750, longitude: -122.4195),
      // Add more toilets as needed
    ];

    // Add markers for each toilet
    for (var toilet in toilets) {
      _markers.add(
        Marker(
          markerId: MarkerId(toilet.id),
          position: LatLng(toilet.latitude, toilet.longitude),
          infoWindow: InfoWindow(
            title: toilet.name,
            snippet: toilet.address,
          ),
        ),
      );
    }

    setState(() {});
  }

  // Function to handle map creation and initial camera position
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addToiletMarkers(); // Add markers after the map is created
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                zoom: 14,
              ),
              markers: _markers, // Show markers on the map
            ),
    );
  }
}
