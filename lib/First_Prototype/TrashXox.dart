import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide GoogleMapController;
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart'; // for web support
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/First_Prototype/StatisticsPage.dart';

class AdminMapPage extends StatefulWidget {
  @override
  _AdminMapPageState createState() => _AdminMapPageState();
}

class _AdminMapPageState extends State<AdminMapPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
  }

  // Function to handle map tap and add a pin
  void _onMapTap(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatisticsPage(
                  position: position, // Ensure 'position' is passed as required by StatisticsPage
                  locationId: position.toString(), // Assuming locationId uses this string format
                ),
              ),
            );
          },
        ),
      );
    });
    _createTableForPin(position); // Call to PHP to create the table
  }

  // Function to create a table in the database when a pin is added
  Future<void> _createTableForPin(LatLng position) async {
    final response = await http.post(
      Uri.parse('http://localhost/flutter_auth/create_table.php'),
      body: {
        'location_id': position.toString(),
        'location_description': 'Description here',
        'water_availability': 'Medium',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Table created successfully.");
    } else {
      Fluttertoast.showToast(msg: "Error creating table.");
    }
  }

  // Function to remove pin and table in the database
  Future<void> _removePin(LatLng position) async {
    final response = await http.post(
      Uri.parse('http://localhost/flutter_auth/remove_pin.php'),
      body: {'location_id': position.toString()},
    );

    if (response.statusCode == 200) {
      setState(() {
        _markers.removeWhere((m) => m.markerId.value == position.toString());
      });
      Fluttertoast.showToast(msg: "Pin and table removed successfully.");
    } else {
      Fluttertoast.showToast(msg: "Error removing pin.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map View')),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller as GoogleMapController;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(45.521563, -122.677433),
          zoom: 13.0,
        ),
        markers: _markers,
        onTap: _onMapTap,
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}