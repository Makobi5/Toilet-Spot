import 'package:flutter/material.dart';
import '../models/toilet.dart';
import '../services/toilet_provider.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _locationController = TextEditingController();
  List<Toilet> _filteredToilets = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchToiletsByLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // If location is empty, try to get current location
      if (_locationController.text.isEmpty) {
        Position? currentPosition = await LocationService().getCurrentLocation();
        
        if (currentPosition != null) {
          _filterToiletsByProximity(
            currentPosition.latitude, 
            currentPosition.longitude
          );
        } else {
          setState(() {
            _errorMessage = 'Could not retrieve current location';
            _isLoading = false;
          });
        }
      } else {
        // TODO: Implement geocoding to convert text location to lat/long
        // For now, we'll use a simple text-based search
        setState(() {
          _filteredToilets = ToiletProvider.searchToilets(_locationController.text);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching toilets: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _filterToiletsByProximity(double latitude, double longitude, {double maxDistance = 5.0}) {
    final allToilets = ToiletProvider.getAllToilets();
    
    _filteredToilets = allToilets.where((toilet) {
      double distance = Geolocator.distanceBetween(
        latitude, 
        longitude, 
        toilet.latitude, 
        toilet.longitude
      ) / 1000; // Convert to kilometers
      
      return distance <= maxDistance;
    }).toList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toilet Spot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Enter Current Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.my_location),
                  onPressed: _searchToiletsByLocation,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchToiletsByLocation,
              child: Text('Search Toilets'),
            ),
            if (_isLoading)
              CircularProgressIndicator(),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage, 
                style: TextStyle(color: Colors.red),
              ),
            Expanded(
              child: _filteredToilets.isEmpty
                ? Center(child: Text('No toilets found'))
                : ListView.builder(
                    itemCount: _filteredToilets.length,
                    itemBuilder: (context, index) {
                      final toilet = _filteredToilets[index];
                      return ListTile(
                        title: Text(toilet.name),
                        subtitle: Text(toilet.description),
                        trailing: Text('Rating: ${toilet.rating}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context, 
                            '/toilet-details', 
                            arguments: toilet
                          );
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
            
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/map');
          }
        },
      ),
    );
  }
}