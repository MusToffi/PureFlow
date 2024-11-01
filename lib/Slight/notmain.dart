import 'package:flutter/material.dart';
import 'package:my_app/First_Prototype/AdminMapPage.dart';
import 'package:my_app/First_Prototype/MapPage.dart';
import 'WaterMap.dart';
import 'WQIPage.dart';

void main() {
  runApp(MaterialApp(
    home: WaterMap(),
  ));
}

class PureFlowHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PureFlow')),
      body: Column(
        children: [
          Expanded(child: WQIPage()),
          //Expanded(child: WaterMap()),
          //Expanded(child: FAQ()),
        ],
      ),
    );
  }
}

class WaterAvailabilityWidget extends StatelessWidget {
  final String ruralStatus = 'High'; // Placeholder
  final String urbanStatus = 'Medium'; // Placeholder

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminMapPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Water Availability"),
            Text("Rural: $ruralStatus"),
            Text("Urban: $urbanStatus"),
          ],
        ),
      ),
    );
  }
}