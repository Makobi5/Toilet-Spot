import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart'; // Import the new service

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(0, 0);
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _checkAndGetLocation();
  }

  void _checkAndGetLocation() async {
    Position? position = await _locationService.getCurrentLocation();
    
    if (position != null) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    } else {
      // Show error message or use a default location
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not retrieve location'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toilet Locations'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 15,
        ),
        mapType: MapType.normal,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}