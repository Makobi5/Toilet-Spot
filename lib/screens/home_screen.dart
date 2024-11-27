import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/toilet.dart'; // Import the Toilet model
import 'package:toilet_spot/screens/map_screen.dart'; // Import the MapScreen
import 'package:toilet_spot/screens/toilet_details_screen.dart';  // Import the ToiletDetailsScreen


// The HomeScreen widget where the search button is added
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This list will hold the fetched toilet data
  late Future<List<Toilet>> toilets;

  // Function to fetch data from the API
  Future<List<Toilet>> fetchToilets() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Convert JSON data to a list of Toilet objects
      return data.map((item) => Toilet.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load toilets');
    }
  }

  @override
  void initState() {
    super.initState();
    toilets = fetchToilets(); // Call the fetch function when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toilet Spot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement the search functionality here
              showSearch(context: context, delegate: ToiletSearchDelegate(toilets: [])); // Pass the list of toilets here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the MapScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()), // Navigates to the MapScreen
              );
            },
            child: Text('View Toilets on Map'),
          ),
          Expanded(
            child: FutureBuilder<List<Toilet>>(
              future: toilets, // Pass the future to FutureBuilder
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No toilets available.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final toilet = snapshot.data![index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(toilet.name),
                          subtitle: Text(toilet.address),
                          trailing: Text('${toilet.latitude}, ${toilet.longitude}', style: const TextStyle(color: Colors.grey)),
                          onTap: () {
                            // Navigate to the ToiletDetailsScreen and pass the selected toilet data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ToiletDetailsScreen(toilet: toilet),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// The ToiletSearchDelegate class to manage search functionality
class ToiletSearchDelegate extends SearchDelegate<Toilet?> {
  final List<Toilet> toilets; // List of toilets to search within

  ToiletSearchDelegate({required this.toilets});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // Close the search and pass null since the return type is nullable
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = toilets
        .where((toilet) => toilet.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final toilet = results[index];
        return ListTile(
          title: Text(toilet.name),
          subtitle: Text(toilet.address),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = toilets
        .where((toilet) => toilet.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final toilet = suggestions[index];
        return ListTile(
          title: Text(toilet.name),
          subtitle: Text(toilet.address),
        );
      },
    );
  }
}
