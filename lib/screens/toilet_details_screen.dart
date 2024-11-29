import 'package:flutter/material.dart';
import '../models/toilet.dart';
import '../widgets/rating_widget.dart';

class ToiletDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Toilet toilet = ModalRoute.of(context)!.settings.arguments as Toilet;

    return Scaffold(
      appBar: AppBar(
        title: Text(toilet.name),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toilet Name and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    toilet.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RatingWidget(
                  rating: toilet.rating,
                  color: Colors.orange,
                  size: 30,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Accessibility Information
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(
                  toilet.isAccessible 
                    ? Icons.accessible 
                    : Icons.not_accessible,
                  color: toilet.isAccessible ? Colors.green : Colors.red,
                ),
                title: Text(
                  toilet.isAccessible 
                    ? 'Wheelchair Accessible' 
                    : 'Not Wheelchair Accessible',
                ),
              ),
            ),
            SizedBox(height: 16),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              toilet.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Location Information
            Text(
              'Location Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Latitude: ${toilet.latitude.toStringAsFixed(4)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Longitude: ${toilet.longitude.toStringAsFixed(4)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement navigation
                  },
                  icon: Icon(Icons.navigation),
                  label: Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Implement review functionality
                  },
                  icon: Icon(Icons.rate_review),
                  label: Text('Write Review'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}