import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart'; // Import the HomeScreen
import 'package:toilet_spot/providers/lib/state/toilet_state_notifier.dart';





void main() {
  runApp(const ProviderScope(child: MyApp())); // Wrap the app with ProviderScope for Riverpod
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toilet Spot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  HomeScreen(), // Set HomeScreen as the starting screen
    );
  }
}
