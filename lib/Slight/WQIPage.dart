import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WQIPage extends StatefulWidget {
  @override
  _RealTimeMonitoringPageState createState() => _RealTimeMonitoringPageState();
}

class _RealTimeMonitoringPageState extends State<WQIPage> {
  Timer? _timer;
  List<Map<String, dynamic>> _locationsData = [];

  @override
  void initState() {
    super.initState();
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRealTimeUpdates() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      // Fetch updated data for each location
      List<Map<String, dynamic>> newData = await fetchLocationDataFromDatabase();
 
      setState(() {
        _locationsData = newData;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchLocationDataFromDatabase() async {
    final url = Uri.parse("http://localhost/water/fetch_location.php");  // Replace with your PHP endpoint
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse JSON data into a List<Map<String, dynamic>>
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Failed to load location data");
      }
    } catch (error) {
      print("Error fetching data: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-Time Monitoring")),
      body: ListView.builder(
        itemCount: _locationsData.length,
        itemBuilder: (context, index) {
          var location = _locationsData[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location ID: ${location['location_id']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Description: ${location['description']}"),
                  Text("Water Quality Index (WQI): ${location['wqi']}"),
                  Text("Water Status: ${location['water_status']}", style: TextStyle(color: location['water_status'] == "Available" ? Colors.green : Colors.red)),
                  SizedBox(height: 150, child: LineChart(_buildLineChartData(location['wqi']))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  LineChartData _buildLineChartData(double wqi) {
    return LineChartData(
      minX: 0,
      maxX: 20,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [FlSpot(0, wqi)],  // Replace with real-time WQI data points
          isCurved: true,
          color: Colors.blue,
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }
}