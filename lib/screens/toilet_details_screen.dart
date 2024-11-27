import 'package:flutter/material.dart';
import 'package:toilet_spot/models/toilet.dart'; // Ensure you import the Toilet model

class ToiletDetailsScreen extends StatelessWidget {
  final Toilet toilet;

  // Constructor to receive the toilet object
  ToiletDetailsScreen({required this.toilet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toilet.name), // Display the toilet name in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toilet name and address
            Text(
              toilet.name,
              style: TextStyle(
                fontSize: 24, // Large font size for prominent text (toilet name)
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              toilet.address,
              style: TextStyle(
                fontSize: 16, // Standard font size for the address
                color: Colors.grey[700], // Grey color for the address
              ),
            ),
            Divider(), // Divider for better readability

            // Toilet ratings and cleanliness
            Text(
              'Rating: ${toilet.rating ?? 'Not rated yet'}',
              style: TextStyle(
                fontSize: 16, // Font size for the rating
                color: Colors.blue, // Optional color for rating text
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cleanliness: ${toilet.cleanliness ?? 'Not available'}',
              style: TextStyle(
                fontSize: 16, // Font size for cleanliness
                color: Colors.blueGrey, // Optional color for cleanliness text
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Accessibility: ${toilet.accessibility ?? 'Unknown'}',
              style: TextStyle(
                fontSize: 16, // Font size for accessibility
                color: Colors.green, // Optional color for accessibility text
              ),
            ),
            Divider(), // Divider for better readability

            // Reviews section
            Text(
              'Reviews:',
              style: TextStyle(
                fontSize: 20, // Font size for the "Reviews" section title
                fontWeight: FontWeight.bold, // Bold text for the section title
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: toilet.reviews?.length ?? 0, // Check if reviews exist
                itemBuilder: (context, index) {
                  final review = toilet.reviews![index]; // Access the reviews
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(review.username),
                      subtitle: Text(review.comment),
                      trailing: Icon(Icons.star, color: Colors.yellow),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
