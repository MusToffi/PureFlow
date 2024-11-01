import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<Location>> fetchLocations() async {
  final response = await http.get(Uri.parse('http://localhost/water/fetch_location.php'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Location.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load locations');
  }
}

class Location {
  final String locationId;
  final String locationDesc;
  final LatLng latLng;

  Location({required this.locationId, required this.locationDesc, required this.latLng});

  factory Location.fromJson(Map<String, dynamic> json) {
    // Assuming LatLng is stored as "latitude,longitude"
    List<String> latLngStr = json['latLng'].split(',');
    double latitude = double.parse(latLngStr[0]);
    double longitude = double.parse(latLngStr[1]);

    return Location(
      locationId: json['location_id'],
      locationDesc: json['location_desc'],
      latLng: LatLng(latitude, longitude),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  List<Location> locations = [];

  @override
  void initState() {
    super.initState();
    fetchLocations().then((data) {
      setState(() {
        locations = data;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(3.778900, 102.716640), // Set to a default position or center on first location
          zoom: 8.0,
        ),
        markers: locations.map((location) {
          return Marker(
            markerId: MarkerId(location.locationId),
            position: location.latLng,
            infoWindow: InfoWindow(title: location.locationDesc),
          );
        }).toSet(),
      ),
    );
  }
}
