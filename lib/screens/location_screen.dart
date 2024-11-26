import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toilet_spot/providers/location_provider.dart' as locationProvider;
import 'package:toilet_spot/models/toilet.dart';
import 'package:toilet_spot/providers/lib/state/toilet_state_notifier.dart' as toiletStateNotifier;

class LocationScreen extends ConsumerWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the toiletLocationsProvider for data updates
    final toiletLocationsAsync = ref.watch(locationProvider.toiletLocationsProvider); // Use the prefix

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toilet Spot'),
      ),
      body: toiletLocationsAsync.when(
        data: (toilets) {
          // Render a list of toilets
          return ListView.builder(
            itemCount: toilets.length,
            itemBuilder: (context, index) {
              final Toilet toilet = toilets[index]; // Use Toilet object
              return ListTile(
                title: Text(toilet.name), // Display toilet name
                subtitle: Text(toilet.address), // Display toilet address
                trailing: Text('${toilet.latitude}, ${toilet.longitude}'), // Display coordinates
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }
}
