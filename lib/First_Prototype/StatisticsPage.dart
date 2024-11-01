import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatisticsPage extends StatefulWidget {
  final String locationId;
  final LatLng position;
  const StatisticsPage(
      {Key? key, required this.locationId, required this.position})
      : super(key: key);

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  Map<String, dynamic>? locationData;

  @override
  void initState() {
    super.initState();
    int passingdata1 = int.parse(widget.locationId);
    fetchLocationData(passingdata1);
  }

  Future<void> fetchLocationData(int locationId) async {
    final response = await http.get(Uri.parse(
        'http://localhost/fetch_location_data.php?location_id=$locationId'));
    if (response.statusCode == 200) {
      setState(() {
        locationData = json.decode(response.body);
      });
    } else {
      print("Failed to load data.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Statistics'),
      ),
      body: locationData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Water Availability')),
                      DataColumn(label: Text('WQI Data')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text(
                              locationData?['location_description'] ?? '')),
                          DataCell(
                              Text(locationData?['water_availability'] ?? '')),
                          DataCell(Text(locationData?['wqi_data'] ?? '')),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: charts.PieChart(
                    _createPieData(locationData?['wqi_percentage'] ?? 0),
                    animate: true,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: charts.LineChart(
                    _createLineData(locationData?['historical_wqi'] ?? []),
                    animate: true,
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.undo),
        tooltip: 'Back',
      ),
    );
  }

  List<charts.Series<ChartData, String>> _createPieData(double wqiPercentage) {
    final data = [
      ChartData('WQI', wqiPercentage),
      ChartData('Other', 100 - wqiPercentage),
    ];

    return [
      charts.Series<ChartData, String>(
        id: 'WQI',
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        data: data,
      )
    ];
  }

  List<charts.Series<ChartData, int>> _createLineData(
      List<dynamic> historicalData) {
    final data =
        historicalData.map((e) => ChartData(e['time'], e['wqi'])).toList();

    return [
      charts.Series<ChartData, int>(
        id: 'Historical WQI',
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        data: data,
      )
    ];
  }
}

class ChartData {
  final dynamic label;
  final double value;
  ChartData(this.label, this.value);
}
