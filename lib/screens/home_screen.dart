import 'package:flutter/material.dart';
import '../models/toilet.dart';
import '../services/toilet_provider.dart';
import '../widgets/rating_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Toilet> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  
  void _performSearch(String query) {
    setState(() {
      _searchResults = ToiletProvider.searchToilets(query);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchResults = ToiletProvider.getAllToilets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toilet Spot'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.pushNamed(context, '/map');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search toilets...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
              ? Center(
                  child: Text(
                    'No toilets found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final toilet = _searchResults[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          toilet.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingWidget(
                              rating: toilet.rating,
                              maxRating: 5,
                              size: 20,
                            ),
                            Text(
                              toilet.isAccessible 
                                ? 'Wheelchair Accessible' 
                                : 'Not Accessible',
                              style: TextStyle(
                                color: toilet.isAccessible 
                                  ? Colors.green 
                                  : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pushNamed(
                            context, 
                            '/toilet-details', 
                            arguments: toilet
                          );
                        },
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add new toilet functionality
          _showAddToiletDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddToiletDialog() {
    // Placeholder for adding new toilet
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Toilet'),
          content: Text('Functionality to be implemented'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}