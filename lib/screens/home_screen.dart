import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/toilet.dart'; // Update this import


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This list will hold the fetched toilet data
  late Future<List<Toilet>> toilets;

  // Function to fetch data from the JSONPlaceholder API
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
      ),
      body: FutureBuilder<List<Toilet>>(
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
                      // Implement navigation or other functionality
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
