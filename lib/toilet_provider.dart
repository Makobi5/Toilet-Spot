import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/toilet.dart';

// Define a StateNotifier to manage the state of toilets
class ToiletStateNotifier extends StateNotifier<List<Toilet>> {
  ToiletStateNotifier() : super([]);

  void addToilet(Toilet toilet) {
    state = [...state, toilet]; // Add a new toilet to the list
  }
}

// Define a Riverpod provider for ToiletStateNotifier
final toiletProvider = StateNotifierProvider<ToiletStateNotifier, List<Toilet>>(
  (ref) => ToiletStateNotifier(),
);
