import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For mobile

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kIsWeb ? 'Map - Web' : 'Map - Mobile'),
      ),
      body: Stack(
        children: [
          // Main content based on the platform
          if (kIsWeb)
            Center(
              child: Text('Map display for web is not yet implemented.'),
              // For web, you could use a map package compatible with web here
            )
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194), // Example coordinates
                zoom: 10,
              ),
            ),
          // Positioned back button at the bottom-left corner
          Positioned(
            bottom: 16,
            left: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Go back to the previous page
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}

