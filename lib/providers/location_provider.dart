import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

// Define a StateProvider for current location
final locationProvider = StateProvider<Position?>((ref) => null);
